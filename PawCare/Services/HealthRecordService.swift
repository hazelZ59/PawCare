import Foundation
import Combine

final class HealthRecordService: ObservableObject {
    static let shared = HealthRecordService()
    @Published private(set) var records: [HealthRecord] = []

    func add(_ record: HealthRecord) {
        records.append(record)
    }

    func update(_ record: HealthRecord) {
        if let idx = records.firstIndex(where: { $0.id == record.id }) {
            records[idx] = record
        }
    }

    func delete(_ record: HealthRecord) {
        records.removeAll { $0.id == record.id }
    }

    func records(for petId: String) -> [HealthRecord] {
        records.filter { $0.petId == petId }
    }

    func records(for petId: String, inLast days: Int) -> [HealthRecord] {
        let cutoff = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        return records(for: petId).filter { $0.timestamp >= cutoff }
    }
}
