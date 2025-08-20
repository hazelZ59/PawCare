import SwiftUI
import UIKit

struct PetListView: View {
    @StateObject private var vm = PetViewModel()
    @State private var showingAdd = false
    @State private var selected: Pet?

    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.pets) { pet in
                    Button { selected = pet } label: {
                        HStack(spacing: 12) {
                            if let data = pet.avatarImageData, let ui = UIImage(data: data) {
                                Image(uiImage: ui).resizable().scaledToFill().frame(width: 44, height: 44).clipShape(Circle())
                            } else { Image(systemName: "pawprint.fill").frame(width: 44, height: 44) }
                            VStack(alignment: .leading) {
                                Text(pet.name).font(.headline)
                                Text("\(pet.species.displayName) • \(pet.breed) • \(pet.age)y").foregroundColor(.secondary)
                            }
                        }
                    }
                    .contextMenu {
                        Button("Edit") { selected = pet }
                        Button("Delete", role: .destructive) { vm.delete(pet: pet) }
                    }
                }
                .onDelete { idx in idx.map { vm.pets[$0] }.forEach { vm.delete(pet: $0) } }
            }
            .navigationTitle("Pets")
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAdd = true }) {
                    Image(systemName: "plus")
                }
            }
            }
            .sheet(isPresented: $showingAdd) { AddOrEditPetView(onSave: { vm.add(pet: $0) }) }
            .sheet(item: $selected) { pet in AddOrEditPetView(existing: pet, onSave: { vm.update(pet: $0) }) }
            .onAppear { vm.loadPets() }
        }
    }
}

struct AddOrEditPetView: View {
    var existing: Pet?
    var onSave: (Pet) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var species: Pet.Species = .cat
    @State private var breed = ""
    @State private var birthDate = Calendar.current.date(byAdding: .year, value: -1, to: Date()) ?? Date()
    @State private var gender: Pet.Gender = .unknown
    @State private var neutered = false
    @State private var avatar: UIImage?
    @State private var showPicker = false

    var breedSuggestions: [String] { species.commonBreeds }
    var canSave: Bool { !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !breed.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

    init(existing: Pet? = nil, onSave: @escaping (Pet) -> Void) {
        self.existing = existing
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Avatar") {
                    HStack {
                        if let avatar = avatar { Image(uiImage: avatar).resizable().scaledToFill().frame(width: 64, height: 64).clipShape(Circle()) }
                        else if let data = existing?.avatarImageData, let ui = UIImage(data: data) { Image(uiImage: ui).resizable().scaledToFill().frame(width: 64, height: 64).clipShape(Circle()) }
                        else { Image(systemName: "person.crop.circle").font(.system(size: 48)) }
                        Button("Choose Photo") { showPicker = true }
                    }
                }
                Section("Basic Info") {
                    TextField("Name", text: $name)
                    Picker("Species", selection: $species) { ForEach(Pet.Species.allCases, id: \.self) { Text($0.displayName).tag($0) } }
                    if !breedSuggestions.isEmpty {
                        Picker("Breed", selection: $breed) { ForEach(breedSuggestions, id: \.self) { Text($0).tag($0) } }
                    } else { TextField("Breed", text: $breed) }
                    DatePicker("Birth Date", selection: $birthDate, displayedComponents: .date)
                    Picker("Gender", selection: $gender) { ForEach(Pet.Gender.allCases, id: \.self) { Text($0.displayName).tag($0) } }
                    Toggle("Neutered", isOn: $neutered)
                }
            }
            .navigationTitle(existing == nil ? "Add Pet" : "Edit Pet")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let data = avatar?.jpegData(compressionQuality: 0.8) ?? existing?.avatarImageData
                        var pet = Pet(id: existing?.id ?? UUID().uuidString, name: name, species: species, breed: breed, birthDate: birthDate, gender: gender, isNeutered: neutered, allergens: [], avatarImageData: data)
                        onSave(pet)
                        dismiss()
                    }.disabled(!canSave)
                }
            }
            .sheet(isPresented: $showPicker) { ImagePicker(image: $avatar) }
            .onAppear { if let p = existing { name = p.name; species = p.species; breed = p.breed; birthDate = p.birthDate; gender = p.gender; neutered = p.isNeutered } }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable { @Binding var image: UIImage?
    func makeUIViewController(context: Context) -> UIImagePickerController { let c = UIImagePickerController(); c.delegate = context.coordinator; return c }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate { let parent: ImagePicker; init(_ parent: ImagePicker) { self.parent = parent }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { if let img = info[.originalImage] as? UIImage { parent.image = img }; picker.dismiss(animated: true) }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { picker.dismiss(animated: true) }
    }
}
