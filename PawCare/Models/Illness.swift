import Foundation

struct Symptom: Identifiable, Codable, Hashable {
    let id: String
    var name: String
    var commonality: Commonality // how often it appears for this illness
    var typicalSeverity: HealthRecord.Severity

    enum Commonality: String, CaseIterable, Codable { case rare, sometimes, common, veryCommon }
    
    init(id: String = UUID().uuidString,
         name: String,
         commonality: Commonality = .common,
         typicalSeverity: HealthRecord.Severity = .mild) {
        self.id = id
        self.name = name
        self.commonality = commonality
        self.typicalSeverity = typicalSeverity
    }
}

struct Illness: Identifiable, Codable {
    let id: String
    var name: String
    var icon: String
    var description: String
    var isPredefined: Bool
    var category: IllnessCategory
    var symptoms: [Symptom] = []
    var aliases: [String] = []
    var contagious: Bool = false
    var emergencyWarning: Bool = false
    var homeCareTips: String? = nil
    
    enum IllnessCategory: String, CaseIterable, Codable {
        case respiratory = "respiratory"
        case digestive = "digestive"
        case skin = "skin"
        case dental = "dental"
        case eye = "eye"
        case ear = "ear"
        case other = "other"
        
        var displayName: String {
            switch self {
            case .respiratory:
                return "Respiratory"
            case .digestive:
                return "Digestive"
            case .skin:
                return "Skin"
            case .dental:
                return "Dental"
            case .eye:
                return "Eye"
            case .ear:
                return "Ear"
            case .other:
                return "Other"
            }
        }
        
        var icon: String {
            switch self {
            case .respiratory:
                return "lungs.fill"
            case .digestive:
                return "stomach.fill"
            case .skin:
                return "pawprint.fill"
            case .dental:
                return "tooth.fill"
            case .eye:
                return "eye.fill"
            case .ear:
                return "ear.fill"
            case .other:
                return "cross.fill"
            }
        }
    }
    
    static let predefinedIllnesses: [Illness] = [
        Illness(id: "1", name: "Upper Respiratory Infection", icon: "lungs.fill", description: "Common cold-like symptoms in cats", isPredefined: true, category: .respiratory),
        Illness(id: "2", name: "Vomiting", icon: "stomach.fill", description: "Gastrointestinal upset", isPredefined: true, category: .digestive),
        Illness(id: "3", name: "Skin Allergy", icon: "pawprint.fill", description: "Itchy skin and rashes", isPredefined: true, category: .skin),
        Illness(id: "4", name: "Dental Disease", icon: "tooth.fill", description: "Gum disease and tooth decay", isPredefined: true, category: .dental),
        Illness(id: "5", name: "Conjunctivitis", icon: "eye.fill", description: "Eye inflammation", isPredefined: true, category: .eye),
        Illness(id: "6", name: "Ear Infection", icon: "ear.fill", description: "Bacterial or fungal ear infection", isPredefined: true, category: .ear)
    ]
    
    init(id: String = UUID().uuidString, name: String, icon: String, description: String, isPredefined: Bool = false, category: IllnessCategory) {
        self.id = id
        self.name = name
        self.icon = icon
        self.description = description
        self.isPredefined = isPredefined
        self.category = category
    }
}
