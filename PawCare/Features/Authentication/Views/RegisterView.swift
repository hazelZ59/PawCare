import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var auth: AuthenticationViewModel
    @State private var step: Step = .enterEmail

    enum Step { case enterEmail, enterOTP }

    var body: some View {
        Form {
            if step == .enterEmail {
                Section(header: Text("Login")) {
                    TextField("Email", text: $auth.email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    if let err = auth.errorMessage { Text(err).foregroundColor(.red) }
                    Button(auth.isLoading ? "Sending..." : "Send OTP") {
                        auth.sendOTP {
                            step = .enterOTP
                        }
                    }.disabled(auth.isLoading || auth.email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            } else {
                Section("Verify OTP") {
                    TextField("6-digit OTP", text: $auth.otp)
                        .keyboardType(.numberPad)
                    if let err = auth.errorMessage { Text(err).foregroundColor(.red) }
                    Button(auth.isLoading ? "Verifying..." : "Verify") {
                        auth.loginWithOTP()
                    }.disabled(auth.isLoading || auth.otp.count != 6)
                }
            }
            Section { Button("Cancel") { dismiss() } }
        }
        .navigationTitle("Register")
    }
}
