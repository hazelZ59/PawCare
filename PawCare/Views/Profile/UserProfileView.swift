import SwiftUI
import PhotosUI

struct UserProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authService: AuthService
    @State private var fullName: String
    @State private var email: String
    @State private var isEditing = false
    
    init(user: User) {
        _fullName = State(initialValue: user.fullName)
        _email = State(initialValue: user.email)
    }
    
    var body: some View {
        ScrollView(showsIndicators: true) {
            VStack(spacing: 24) {
                // Profile header
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 120, height: 120)
                        
                        if let profileImageURL = authService.currentUser?.profileImageURL {
                            AsyncImage(url: profileImageURL) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(.white)
                                }
                            }
                        } else {
                            Image(systemName: "person.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                        }
                    }
                    
                    Text(fullName)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(email)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                
                // User information
                VStack(alignment: .leading, spacing: 0) {
                    Text("Account Information")
                        .font(.headline)
                        .padding()
                    
                    Divider()
                    
                    InfoRow(label: "Full Name", value: fullName)
                    InfoRow(label: "Email", value: email)
                    InfoRow(label: "Member Since", value: "September 2023") // This would be dynamic in a real app
                }
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                
                // Action buttons
                VStack(spacing: 12) {
                    Button(action: {
                        isEditing = true
                    }) {
                        Text("Edit Profile")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        authService.signOut()
                    }) {
                        Text("Sign Out")
                            .font(.headline)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 100) // Extra padding for tab bar
            }
        }
        .navigationTitle("User Profile")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isEditing) {
            EditUserProfileView(fullName: fullName, email: email) { updatedName, updatedEmail in
                // In a real app, you would update the user profile on the backend
                fullName = updatedName
                // Email typically requires verification before updating
                // For demo purposes, we'll just update it locally
                email = updatedEmail
            }
        }
    }
}

struct EditUserProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var fullName: String
    @State private var email: String
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedPhotoData: Data?
    
    let onSave: (String, String) -> Void
    
    init(fullName: String, email: String, onSave: @escaping (String, String) -> Void) {
        _fullName = State(initialValue: fullName)
        _email = State(initialValue: email)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile Photo")) {
                    HStack {
                        Spacer()
                        
                        ZStack {
                            if let selectedPhotoData = selectedPhotoData,
                               let uiImage = UIImage(data: selectedPhotoData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } else {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical)
                    
                    PhotosPicker(
                        selection: $selectedPhotoItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Label("Select Photo", systemImage: "photo")
                        }
                        .onChange(of: selectedPhotoItem) { newItem in
                            Task {
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    selectedPhotoData = data
                                }
                            }
                        }
                }
                
                Section(header: Text("Personal Information")) {
                    TextField("Full Name", text: $fullName)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                Section {
                    Button("Change Password") {
                        // In a real app, this would navigate to a password change screen
                    }
                    .foregroundColor(.blue)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(fullName, email)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserProfileView(user: User.sample)
                .environmentObject(AuthService())
        }
    }
}
