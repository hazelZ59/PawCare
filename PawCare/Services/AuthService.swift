import Foundation
import SwiftUI
import Combine

class AuthService: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var error: String?
    
    // For demo purposes, we'll use this to simulate authentication
    func login(email: String, password: String) {
        isLoading = true
        error = nil
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Simple validation
            if email.isEmpty || password.isEmpty {
                self.error = "Email and password cannot be empty"
                self.isLoading = false
                return
            }
            
            // Demo login - in a real app, you would validate against a backend
            if email.lowercased() == "demo@example.com" && password == "password" {
                self.currentUser = User(
                    id: "user1",
                    fullName: "John Smith",
                    email: email,
                    profileImageURL: nil
                )
                self.isAuthenticated = true
            } else {
                self.error = "Invalid email or password"
            }
            
            self.isLoading = false
        }
    }
    
    func register(fullName: String, email: String, password: String, confirmPassword: String) {
        isLoading = true
        error = nil
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Simple validation
            if fullName.isEmpty || email.isEmpty || password.isEmpty {
                self.error = "All fields are required"
                self.isLoading = false
                return
            }
            
            if password != confirmPassword {
                self.error = "Passwords do not match"
                self.isLoading = false
                return
            }
            
            // Demo registration - in a real app, you would create a user in a backend
            self.currentUser = User(
                id: "user1",
                fullName: fullName,
                email: email,
                profileImageURL: nil
            )
            self.isAuthenticated = true
            self.isLoading = false
        }
    }
    
    func signOut() {
        currentUser = nil
        isAuthenticated = false
    }
    
    func resetPassword(email: String) {
        isLoading = true
        error = nil
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Simple validation
            if email.isEmpty {
                self.error = "Email cannot be empty"
                self.isLoading = false
                return
            }
            
            // Demo password reset - in a real app, you would send a reset email
            self.isLoading = false
            // Show success message in the UI
        }
    }
}
