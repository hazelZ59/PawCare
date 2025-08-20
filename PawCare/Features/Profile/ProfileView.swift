import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var auth: AuthenticationViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section("Account") {
                    Text(auth.email.isEmpty ? "Signed in" : auth.email)
                }

                Section {
                    Button("Logout", role: .destructive) {
                        auth.logout()
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(AuthenticationViewModel())
    }
}
