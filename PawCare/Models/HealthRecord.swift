import Foundation
import SwiftUI

struct HealthRecord: Identifiable, Codable {
    var id: String
    var catId: String
    var title: String
    var date: Date
    var type: RecordType
    var veterinarian: String?
    var notes: String?
    var attachments: [Attachment]
    var reminderDate: Date?
    
    enum RecordType: String, Codable, CaseIterable, Identifiable {
        case vaccination = "Vaccination"
        case medication = "Medication"
        case vetVisit = "Vet Visit"
        case symptom = "Symptom"
        
        var id: String { self.rawValue }
        
        var icon: String {
            switch self {
            case .vaccination:
                return "cross.case"
            case .medication:
                return "pill"
            case .vetVisit:
                return "heart.text.square"
            case .symptom:
                return "exclamationmark.triangle"
            }
        }
        
        var color: Color {
            switch self {
            case .vaccination:
                return .blue
            case .medication:
                return .red
            case .vetVisit:
                return .green
            case .symptom:
                return .yellow
            }
        }
    }
    
    struct Attachment: Identifiable, Codable {
        var id: String
        var name: String
        var type: AttachmentType
        var url: URL
        var size: Int? // Size in bytes
        
        enum AttachmentType: String, Codable {
            case image
            case pdf
            case document
            
            var icon: String {
                switch self {
                case .image:
                    return "photo"
                case .pdf:
                    return "doc.text"
                case .document:
                    return "doc"
                }
            }
        }
    }
    
    // Sample data for preview
    static let samples = [
        HealthRecord(
            id: "hr1",
            catId: "cat1",
            title: "Vomiting",
            date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
            type: .symptom,
            veterinarian: nil,
            notes: "Vomited twice after eating, monitoring for 24 hours",
            attachments: [
                Attachment(
                    id: "a1",
                    name: "symptom_photo.jpg",
                    type: .image,
                    url: URL(string: "https://images.unsplash.com/photo-1583524505974-6facd53f4597")!,
                    size: nil
                )
            ],
            reminderDate: nil
        ),
        HealthRecord(
            id: "hr2",
            catId: "cat1",
            title: "Rabies Vaccination",
            date: Calendar.current.date(byAdding: .month, value: -1, to: Date())!,
            type: .vaccination,
            veterinarian: "Dr. Smith",
            notes: nil,
            attachments: [
                Attachment(
                    id: "a2",
                    name: "Vaccination_Certificate.pdf",
                    type: .pdf,
                    url: URL(string: "https://example.com/vaccination.pdf")!,
                    size: 245 * 1024
                )
            ],
            reminderDate: Calendar.current.date(byAdding: .year, value: 1, to: Calendar.current.date(byAdding: .month, value: -1, to: Date())!)
        ),
        HealthRecord(
            id: "hr3",
            catId: "cat1",
            title: "Annual Checkup",
            date: Calendar.current.date(byAdding: .month, value: -1, to: Date())!,
            type: .vetVisit,
            veterinarian: "Dr. Smith",
            notes: "All vitals normal, dental cleaning recommended",
            attachments: [
                Attachment(
                    id: "a3",
                    name: "Annual_Checkup_Report.pdf",
                    type: .pdf,
                    url: URL(string: "https://example.com/checkup.pdf")!,
                    size: 1200 * 1024
                )
            ],
            reminderDate: nil
        ),
        HealthRecord(
            id: "hr4",
            catId: "cat1",
            title: "Antibiotics",
            date: Calendar.current.date(byAdding: .month, value: -3, to: Date())!,
            type: .medication,
            veterinarian: "Dr. Johnson",
            notes: "For respiratory infection - completed",
            attachments: [],
            reminderDate: nil
        ),
        HealthRecord(
            id: "hr5",
            catId: "cat1",
            title: "Dental Cleaning",
            date: Calendar.current.date(byAdding: .month, value: -4, to: Date())!,
            type: .vetVisit,
            veterinarian: "Dr. Johnson",
            notes: "Routine cleaning, no extractions needed",
            attachments: [
                Attachment(
                    id: "a4",
                    name: "dental_photo.jpg",
                    type: .image,
                    url: URL(string: "https://images.unsplash.com/photo-1559321966-04643588828f")!,
                    size: nil
                )
            ],
            reminderDate: nil
        )
    ]
}