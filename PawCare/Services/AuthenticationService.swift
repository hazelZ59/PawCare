import Foundation
import Combine

final class AuthenticationService: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?

    func register(email: String, completion: @escaping (Result<User, Error>) -> Void) {
        isLoading = true
        errorMessage = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.isLoading = false
            guard self.isValidEmail(email) else {
                completion(.failure(NSError(domain: "PawCare", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid email format"])) )
                return
            }
            let user = User(id: UUID().uuidString, email: email)
            self.currentUser = user
            self.isAuthenticated = true
            completion(.success(user))
        }
    }

    func loginWithPassword(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        isLoading = true
        errorMessage = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.isLoading = false
            guard self.isValidEmail(email), password.count >= 6 else {
                completion(.failure(NSError(domain: "PawCare", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials"])) )
                return
            }
            let user = User(id: UUID().uuidString, email: email)
            self.currentUser = user
            self.isAuthenticated = true
            completion(.success(user))
        }
    }

    func sendOTP(to email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard isValidEmail(email) else {
            completion(.failure(NSError(domain: "PawCare", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid email format"])) )
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            completion(.success(()))
        }
    }

    func loginWithOTP(email: String, otp: String, completion: @escaping (Result<User, Error>) -> Void) {
        isLoading = true
        errorMessage = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.isLoading = false
            guard self.isValidEmail(email), otp.count == 6, otp.allSatisfy({ $0.isNumber }) else {
                completion(.failure(NSError(domain: "PawCare", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid OTP"])) )
                return
            }
            let user = User(id: UUID().uuidString, email: email)
            self.currentUser = user
            self.isAuthenticated = true
            completion(.success(user))
        }
    }

    func logout() {
        currentUser = nil
        isAuthenticated = false
    }

    private func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
}
