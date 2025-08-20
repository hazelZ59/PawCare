import Foundation
import Combine

final class SummaryViewModel: ObservableObject {
    @Published var current: HealthSummary?
    @Published var selectedRange: SummaryService.TimeRange = .monthly

    private let service = SummaryService()

    func generate(for petId: String, records: [HealthRecord]) {
        current = service.generateHealthSummary(for: petId, timeRange: selectedRange, records: records)
    }
}
