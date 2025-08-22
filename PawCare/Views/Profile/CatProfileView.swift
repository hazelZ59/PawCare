import SwiftUI

struct CatProfileView: View {
    @EnvironmentObject var dataService: DataService
    @State private var cat: Cat
    @State private var isEditing = false
    
    init(cat: Cat) {
        _cat = State(initialValue: cat)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Profile header
                VStack(spacing: 12) {
                    if let imageURL = cat.imageURL {
                        AsyncImage(url: imageURL) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                            } else if phase.error != nil {
                                Image(systemName: "pawprint.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.white)
                            } else {
                                ProgressView()
                            }
                        }
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.blue, lineWidth: 3)
                        )
                    } else {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 120, height: 120)
                            .overlay(
                                Image(systemName: "pawprint.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.blue)
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.blue, lineWidth: 3)
                            )
                    }
                    
                    Text(cat.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("\(cat.breed.rawValue) • \(cat.age) years old")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.white)
                
                // Basic information
                VStack(alignment: .leading, spacing: 0) {
                    Text("Basic Information")
                        .font(.headline)
                        .padding()
                    
                    Divider()
                    
                    InfoRow(label: "Date of Birth", value: formatDate(cat.dateOfBirth))
                    InfoRow(label: "Gender", value: cat.gender.rawValue)
                    BreedRow(breed: cat.breed)
                    InfoRow(label: "Spayed/Neutered", value: cat.isSpayedOrNeutered ? "Yes" : "No")
                }
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                
                // Medical information
                VStack(alignment: .leading, spacing: 0) {
                    Text("Medical Information")
                        .font(.headline)
                        .padding()
                    
                    Divider()
                    
                    InfoRow(label: "Blood Type", value: cat.bloodType ?? "Unknown")
                    InfoRow(label: "Allergies", value: cat.allergies.isEmpty ? "None" : cat.allergies.joined(separator: ", "))
                    InfoRow(label: "Chronic Conditions", value: cat.chronicConditions.isEmpty ? "None" : cat.chronicConditions.joined(separator: ", "))
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
                        // Navigate to add medical record
                    }) {
                        Text("Add Medical Record")
                            .font(.headline)
                            .foregroundColor(.blue)
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
        .navigationTitle("Cat Profile")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isEditing) {
            EditCatProfileView(cat: cat) { updatedCat in
                cat = updatedCat
                dataService.updateCat(updatedCat)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding()
        .background(Color.white)
        
        Divider()
            .padding(.horizontal)
    }
}

struct BreedRow: View {
    let breed: CatBreed
    
    var body: some View {
        HStack {
            Text("Breed")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            HStack {
                Text(breed.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Image(systemName: "chevron.down")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.white)
        
        Divider()
            .padding(.horizontal)
    }
}

struct EditCatProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var cat: Cat
    let onSave: (Cat) -> Void
    
    @State private var name: String
    @State private var breed: CatBreed
    @State private var dateOfBirth: Date
    @State private var gender: Cat.Gender
    @State private var isSpayedOrNeutered: Bool
    @State private var bloodType: String
    @State private var allergies: String
    @State private var chronicConditions: String
    
    init(cat: Cat, onSave: @escaping (Cat) -> Void) {
        self.onSave = onSave
        _cat = State(initialValue: cat)
        _name = State(initialValue: cat.name)
        _breed = State(initialValue: cat.breed)
        _dateOfBirth = State(initialValue: cat.dateOfBirth)
        _gender = State(initialValue: cat.gender)
        _isSpayedOrNeutered = State(initialValue: cat.isSpayedOrNeutered)
        _bloodType = State(initialValue: cat.bloodType ?? "")
        _allergies = State(initialValue: cat.allergies.joined(separator: ", "))
        _chronicConditions = State(initialValue: cat.chronicConditions.joined(separator: ", "))
    }
    
    var body: some View {
        NavigationView {
            Form {
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
                
                Section(header: Text("Medical Information")) {
                    TextField("Blood Type", text: $bloodType)
                    TextField("Allergies (comma separated)", text: $allergies)
                    TextField("Chronic Conditions (comma separated)", text: $chronicConditions)
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
                        var updatedCat = cat
                        updatedCat.name = name
                        updatedCat.breed = breed
                        updatedCat.dateOfBirth = dateOfBirth
                        updatedCat.gender = gender
                        updatedCat.isSpayedOrNeutered = isSpayedOrNeutered
                        updatedCat.bloodType = bloodType.isEmpty ? nil : bloodType
                        updatedCat.allergies = allergies.isEmpty ? [] : allergies.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
                        updatedCat.chronicConditions = chronicConditions.isEmpty ? [] : chronicConditions.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
                        
                        onSave(updatedCat)
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CatProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CatProfileView(cat: Cat.sample)
                .environmentObject(DataService())
        }
    }
}
