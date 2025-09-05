import SwiftUI
import PhotosUI

struct AddCatView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataService: DataService
    @EnvironmentObject var authService: AuthService
    
    @State private var name = ""
    @State private var breed = CatBreed.maineCoon
    @State private var dateOfBirth = Date()
    @State private var gender = Cat.Gender.male
    @State private var isSpayedOrNeutered = false
    @State private var bloodType = ""
    @State private var allergies = ""
    @State private var chronicConditions = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var isLoading = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack {
                        if let selectedImageData,
                           let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                        } else {
                            Circle()
                                .fill(Color.blue.opacity(0.2))
                                .frame(width: 120, height: 120)
                                .overlay(
                                    Image(systemName: "pawprint.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.blue)
                                )
                        }
                        
                        PhotosPicker(
                            selection: $selectedItem,
                            matching: .images,
                            photoLibrary: .shared()) {
                                Text("Select Photo")
                                    .foregroundColor(.blue)
                            }
                            .onChange(of: selectedItem) { newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        selectedImageData = data
                                    }
                                }
                            }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                }
                .listRowBackground(Color.clear)
                
                Section(header: Text("Basic Information")) {
                    TextField("Name", text: $name)
                    
                    Picker("Breed", selection: $breed) {
                        ForEach(CatBreed.allCases) { breed in
                            Text(breed.rawValue).tag(breed)
                        }
                    }
                    
                    DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                    
                    Picker("Gender", selection: $gender) {
                        ForEach(Cat.Gender.allCases, id: \.self) { gender in
                            Text(gender.rawValue).tag(gender)
                        }
                    }
                    
                    Toggle("Spayed/Neutered", isOn: $isSpayedOrNeutered)
                }
                
                Section(header: Text("Medical Information (Optional)")) {
                    TextField("Blood Type", text: $bloodType)
                    TextField("Allergies (comma separated)", text: $allergies)
                    TextField("Chronic Conditions (comma separated)", text: $chronicConditions)
                }
            }
            .navigationTitle("Add New Cat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveCat()
                    }
                    .disabled(name.isEmpty || isLoading)
                }
            }
            .overlay {
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func saveCat() {
        guard !name.isEmpty else {
            errorMessage = "Please enter a name for your cat"
            showError = true
            return
        }
        
        guard let userId = authService.currentUser?.id else {
            errorMessage = "You must be logged in to add a cat"
            showError = true
            return
        }
        
        isLoading = true
        
        // In a real app, you would upload the image to a server and get a URL back
        // For now, we'll just create the cat without an image URL
        let newCat = Cat(
            id: UUID().uuidString,
            name: name,
            breed: breed,
            dateOfBirth: dateOfBirth,
            gender: gender,
            isSpayedOrNeutered: isSpayedOrNeutered,
            bloodType: bloodType.isEmpty ? nil : bloodType,
            allergies: allergies.isEmpty ? [] : allergies.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) },
            chronicConditions: chronicConditions.isEmpty ? [] : chronicConditions.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) },
            imageURL: nil,
            ownerId: userId
        )
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            dataService.addCat(newCat)
            isLoading = false
            dismiss()
        }
    }
}

struct AddCatView_Previews: PreviewProvider {
    static var previews: some View {
        AddCatView()
            .environmentObject(DataService())
            .environmentObject(AuthService())
    }
}
