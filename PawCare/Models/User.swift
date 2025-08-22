import Foundation

struct User: Identifiable, Codable {
    var id: String
    var fullName: String
    var email: String
    var profileImageURL: URL?
    
    // For demo purposes
    static let sample = User(
        id: "user1",
        fullName: "John Smith",
        email: "john.smith@example.com",
        profileImageURL: nil
    )
}