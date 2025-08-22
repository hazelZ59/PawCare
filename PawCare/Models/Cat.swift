import Foundation
import SwiftUI

struct Cat: Identifiable, Codable {
    var id: String
    var name: String
    var breed: CatBreed
    var dateOfBirth: Date
    var gender: Gender
    var isSpayedOrNeutered: Bool
    var bloodType: String?
    var allergies: [String]
    var chronicConditions: [String]
    var imageURL: URL?
    var ownerId: String
    
    var age: Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: dateOfBirth, to: Date())
        return ageComponents.year ?? 0
    }
    
    enum Gender: String, Codable, CaseIterable {
        case male = "Male"
        case female = "Female"
    }
    
    // For demo purposes
    static let sample = Cat(
        id: "cat1",
        name: "Whiskers",
        breed: .maineCoon,
        dateOfBirth: Calendar.current.date(byAdding: .year, value: -3, to: Date())!,
        gender: .female,
        isSpayedOrNeutered: true,
        bloodType: "A",
        allergies: ["Chicken", "Dairy"],
        chronicConditions: [],
        imageURL: URL(string: "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba"),
        ownerId: "user1"
    )
}

enum CatBreed: String, Codable, CaseIterable, Identifiable {
    case maineCoon = "Maine Coon"
    case persian = "Persian"
    case siamese = "Siamese"
    case ragdoll = "Ragdoll"
    case bengal = "Bengal"
    case sphynx = "Sphynx"
    case britishShorthair = "British Shorthair"
    case abyssinian = "Abyssinian"
    case scottishFold = "Scottish Fold"
    case norwegianForestCat = "Norwegian Forest Cat"
    case other = "Other"
    
    var id: String { self.rawValue }
}
