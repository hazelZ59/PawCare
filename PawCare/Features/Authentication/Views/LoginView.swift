import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthenticationViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Login")) {
                    TextField("Email", text: $auth.email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)

                    SecureField("Password", text: $auth.password)

                    if let err = auth.errorMessage {
                        Text(err)
                            .foregroundColor(.red)
                    }

                    Button(auth.isLoading ? "Loading..." : "Login") {
                        auth.loginWithPassword()
                    }
                    .disabled(auth.isLoading || auth.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || auth.password.count < 6)

                    Button("Login with OTP (demo)") {
                        auth.sendOTP {
                            // Simulated auto-OTP for demo
                            auth.otp = "123456"
                            auth.loginWithOTP()
                        }
                    }
                    .disabled(auth.isLoading)
                }

                Section {
                    NavigationLink("Register") {
                        RegisterView().environmentObject(auth)
                    }
                }
            }
            .navigationTitle("PawCare")
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AuthenticationViewModel())
    }
}
