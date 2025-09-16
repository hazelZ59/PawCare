import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            HealthRecordsView()
                .tabItem {
                    Label("Health", systemImage: "clipboard.fill")
                }
                .tag(1)
            
            WeightTrackingView()
                .tabItem {
                    Label("Weight", systemImage: "scalemass.fill")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(3)
        }
        .accentColor(.blue)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(DataService())
            .environmentObject(AuthService())
    }
}