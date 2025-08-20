import Foundation

struct Pet: Identifiable, Codable, Equatable {
    let id: String
    var name: String
    var species: Species
    var breed: String
    var birthDate: Date
    var gender: Gender
    var isNeutered: Bool
    var allergens: [String]
    var avatarImageData: Data?
    var createdAt: Date

    var age: Int { Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year ?? 0 }

    enum Species: String, CaseIterable, Codable { case cat, dog, other
        var displayName: String { self == .cat ? "Cat" : self == .dog ? "Dog" : "Other" }
        var commonBreeds: [String] {
            switch self {
            case .cat: return ["Domestic Shorthair","British Shorthair","Siamese","Persian","Ragdoll","Bengal","Maine Coon"]
            case .dog: return ["Labrador Retriever","Golden Retriever","French Bulldog","Poodle","German Shepherd","Shiba Inu","Corgi"]
            case .other: return []
            }
        }
    }

    enum Gender: String, CaseIterable, Codable { case male = "male", female = "female", unknown = "unknown"
        var displayName: String { self == .male ? "Male" : self == .female ? "Female" : "Unknown" }
    }

    init(id: String = UUID().uuidString,
         name: String,
         species: Species = .cat,
         breed: String,
         birthDate: Date,
         gender: Gender,
         isNeutered: Bool,
         allergens: [String] = [],
         avatarImageData: Data? = nil) {
        self.id = id
        self.name = name
        self.species = species
        self.breed = breed
        self.birthDate = birthDate
        self.gender = gender
        self.isNeutered = isNeutered
        self.allergens = allergens
        self.avatarImageData = avatarImageData
        self.createdAt = Date()
    }
}
