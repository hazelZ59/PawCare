import Foundation
import Combine

struct HealthSummary {
    let petId: String
    let timeRange: SummaryService.TimeRange
    let totalRecords: Int
}

final class SummaryService: ObservableObject {
    enum TimeRange: String, CaseIterable { case weekly, monthly, quarterly, yearly
        var days: Int { switch self { case .weekly: return 7; case .monthly: return 30; case .quarterly: return 90; case .yearly: return 365 } }
        var displayName: String { rawValue.capitalized }
    }

    func generateHealthSummary(for petId: String, timeRange: TimeRange, records: [HealthRecord]) -> HealthSummary {
        let cutoff = Calendar.current.date(byAdding: .day, value: -timeRange.days, to: Date()) ?? Date()
        let filtered = records.filter { $0.timestamp >= cutoff }
        return HealthSummary(petId: petId, timeRange: timeRange, totalRecords: filtered.count)
    }
}
