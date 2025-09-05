import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authService: AuthService
    @State private var email = ""
    @State private var password = ""
    @State private var showingRegister = false
    @State private var showingForgotPassword = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Logo and app name
            VStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue)
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: "pawprint.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                }
                
                Text("PawCare")
                    .font(.system(size: 28, weight: .bold))
                
                Text("Track your cat's health with ease")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 60)
            .padding(.bottom, 40)
            
            // Login/Register Tabs
            HStack {
                Button(action: {
                    showingRegister = false
                }) {
                    Text("Login")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(!showingRegister ? Color.white : Color.clear)
                        .foregroundColor(!showingRegister ? .blue : .gray)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    showingRegister = true
                }) {
                    Text("Register")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(showingRegister ? Color.white : Color.clear)
                        .foregroundColor(showingRegister ? .blue : .gray)
                        .cornerRadius(8)
                }
            }
            .padding(4)
            .background(Color(.systemGray5))
            .cornerRadius(10)
            .padding(.bottom, 30)
            
            if showingRegister {
                RegisterForm()
            } else {
                // Login Form
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        TextField("your@email.com", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        SecureField("••••••••", text: $password)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: { showingForgotPassword = true }) {
                            Text("Forgot Password?")
                                .font(.footnote)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Button(action: {
                        authService.login(email: email, password: password)
                    }) {
                        Text("Login")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(authService.isLoading)
                    .opacity(authService.isLoading ? 0.6 : 1)
                    .overlay {
                        if authService.isLoading {
                            ProgressView()
                                .tint(.white)
                        }
                    }
                    
                    if let error = authService.error {
                        Text(error)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.top, 8)
                    }
                }
            }
            
            Spacer()
            
            // Terms and conditions
            Text("By continuing, you agree to our Terms of Service and Privacy Policy")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
        }
        .padding(.horizontal)
        .sheet(isPresented: $showingForgotPassword) {
            ForgotPasswordView()
        }
    }
}

struct RegisterForm: View {
    @EnvironmentObject var authService: AuthService
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Full Name")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                TextField("John Smith", text: $fullName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Email")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                TextField("your@email.com", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Password")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                SecureField("••••••••", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Confirm Password")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                SecureField("••••••••", text: $confirmPassword)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            }
            
            Button(action: {
                authService.register(fullName: fullName, email: email, password: password, confirmPassword: confirmPassword)
            }) {
                Text("Create Account")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .disabled(authService.isLoading)
            .opacity(authService.isLoading ? 0.6 : 1)
            .overlay {
                if authService.isLoading {
                    ProgressView()
                        .tint(.white)
                }
            }
            
            if let error = authService.error {
                Text(error)
                    .font(.footnote)
                    .foregroundColor(.red)
                    .padding(.top, 8)
            }
        }
    }
}

struct ForgotPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authService: AuthService
    @State private var email = ""
    @State private var showingSuccess = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Reset Password")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Text("Enter your email address and we'll send you a link to reset your password")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Email")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    TextField("your@email.com", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .padding(.top)
                
                Button(action: {
                    authService.resetPassword(email: email)
                    showingSuccess = true
                }) {
                    Text("Send Reset Link")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .disabled(authService.isLoading)
                .opacity(authService.isLoading ? 0.6 : 1)
                .overlay {
                    if authService.isLoading {
                        ProgressView()
                            .tint(.white)
                    }
                }
                
                if let error = authService.error {
                    Text(error)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.top, 8)
                }
                
                if showingSuccess {
                    Text("Reset link sent! Please check your email.")
                        .font(.footnote)
                        .foregroundColor(.green)
                        .padding(.top, 8)
                }
                
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthService())
    }
}