import Foundation

struct HealthRecord: Identifiable, Codable {
    let id: String
    let petId: String
    let illnessId: String
    var description: String
    var timestamp: Date
    var attachments: [Attachment]
    var severity: Severity
    var notes: String?
    
    enum Severity: String, CaseIterable, Codable {
        case mild = "mild"
        case moderate = "moderate"
        case severe = "severe"
        
        var displayName: String {
            switch self {
            case .mild:
                return "Mild"
            case .moderate:
                return "Moderate"
            case .severe:
                return "Severe"
            }
        }
    }
    
    struct Attachment: Identifiable, Codable {
        let id: String
        let fileName: String
        let fileType: FileType
        let filePath: String
        let uploadedAt: Date
        
        enum FileType: String, CaseIterable, Codable {
            case image = "image"
            case video = "video"
            case document = "document"
            
            var displayName: String {
                switch self {
                case .image:
                    return "Image"
                case .video:
                    return "Video"
                case .document:
                    return "Document"
                }
            }
        }
        
        init(id: String = UUID().uuidString, fileName: String, fileType: FileType, filePath: String) {
            self.id = id
            self.fileName = fileName
            self.fileType = fileType
            self.filePath = filePath
            self.uploadedAt = Date()
        }
    }
    
    init(id: String = UUID().uuidString, petId: String, illnessId: String, description: String, timestamp: Date = Date(), attachments: [Attachment] = [], severity: Severity = .mild, notes: String? = nil) {
        self.id = id
        self.petId = petId
        self.illnessId = illnessId
        self.description = description
        self.timestamp = timestamp
        self.attachments = attachments
        self.severity = severity
        self.notes = notes
    }
}
