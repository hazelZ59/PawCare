import Foundation

struct User: Identifiable, Codable {
    let id: String
    let email: String
    var name: String?
    var language: Language
    var createdAt: Date
    
    enum Language: String, CaseIterable, Codable {
        case english = "en"
        case simplifiedChinese = "zh-Hans"
        case traditionalChinese = "zh-Hant"
        
        var displayName: String {
            switch self {
            case .english:
                return "English"
            case .simplifiedChinese:
                return "简体中文"
            case .traditionalChinese:
                return "繁體中文"
            }
        }
    }
    
    init(id: String, email: String, name: String? = nil, language: Language = .english) {
        self.id = id
        self.email = email
        self.name = name
        self.language = language
        self.createdAt = Date()
    }
}
