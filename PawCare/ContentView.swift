import SwiftUI

struct ContentView: View {
    @StateObject private var auth = AuthenticationViewModel()

    var body: some View {
        Group {
            if auth.isAuthenticated {
                TabView {
                    PetListView()
                        .tabItem { Label("Pets", systemImage: "pawprint.fill") }
                    RecordsListView()
                        .tabItem { Label("Records", systemImage: "doc.text") }
                    SummaryView()
                        .tabItem { Label("Summary", systemImage: "chart.bar.fill") }
                    ProfileView()
                        .tabItem { Label("Profile", systemImage: "person.fill") }
                }
                .environmentObject(auth)
            } else {
                NavigationStack { LoginView().environmentObject(auth) }
            }
        }
    }
}
