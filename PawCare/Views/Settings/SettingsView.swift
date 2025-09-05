import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authService: AuthService
    @State private var notificationsEnabled = true
    @State private var units = "Metric"
    
    var body: some View {
        NavigationView {
            List {
                // User profile section
                if let user = authService.currentUser {
                    Section {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 60, height: 60)
                                
                                Image(systemName: "person")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.fullName)
                                    .font(.headline)
                                
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                // App settings
                Section(header: Text("App Settings")) {
                    SettingToggleRow(icon: "bell.fill", iconColor: .blue, title: "Notifications", isOn: $notificationsEnabled)
                    
                    SettingNavigationRow(icon: "ruler", iconColor: .red, title: "Units", value: units)
                }
                
                // About section
                Section(header: Text("About")) {
                    SettingValueRow(icon: "info.circle", iconColor: .gray, title: "App Version", value: "1.0.0")
                    
                    SettingNavigationRow(icon: "questionmark.circle", iconColor: .green, title: "Help & Support")
                }
                
                // Sign out button
                Section {
                    Button(action: {
                        authService.signOut()
                    }) {
                        Text("Sign Out")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Settings")
        }
    }
}

struct SettingToggleRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            SettingIcon(icon: icon, color: iconColor)
            
            Text(title)
                .font(.body)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
    }
}

struct SettingNavigationRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    var value: String? = nil
    
    var body: some View {
        HStack {
            SettingIcon(icon: icon, color: iconColor)
            
            Text(title)
                .font(.body)
            
            Spacer()
            
            if let value = value {
                Text(value)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct SettingValueRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            SettingIcon(icon: icon, color: iconColor)
            
            Text(title)
                .font(.body)
            
            Spacer()
            
            Text(value)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

struct SettingIcon: View {
    let icon: String
    let color: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 36, height: 36)
            
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.white)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AuthService())
    }
}