import Foundation
import Combine

final class AuthenticationViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var otp: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: User?

    private let service = AuthenticationService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        service.$isAuthenticated.assign(to: &self.$isAuthenticated)
        service.$isLoading.assign(to: &self.$isLoading)
        service.$errorMessage.assign(to: &self.$errorMessage)
        service.$currentUser.assign(to: &self.$currentUser)
    }

    func register() {
        isLoading = true
        service.register(email: email) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.isAuthenticated = true
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func loginWithPassword() {
        isLoading = true
        service.loginWithPassword(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.isAuthenticated = true
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func sendOTP(completion: (() -> Void)? = nil) {
        service.sendOTP(to: email) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    completion?()
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func loginWithOTP() {
        isLoading = true
        service.loginWithOTP(email: email, otp: otp) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.isAuthenticated = true
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func logout() {
        service.logout()
        isAuthenticated = false
        email = ""; password = ""; otp = ""
    }
}
