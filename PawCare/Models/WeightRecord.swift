import Foundation

struct WeightRecord: Identifiable, Codable {
    var id: String
    var catId: String
    var weight: Double // in kg
    var date: Date
    var notes: String?
    
    // Sample data for preview
    static let samples = [
        WeightRecord(
            id: "wr1",
            catId: "cat1",
            weight: 5.2,
            date: Calendar.current.date(from: DateComponents(year: 2023, month: 9, day: 1))!,
            notes: nil
        ),
        WeightRecord(
            id: "wr2",
            catId: "cat1",
            weight: 5.3,
            date: Calendar.current.date(from: DateComponents(year: 2023, month: 8, day: 1))!,
            notes: nil
        ),
        WeightRecord(
            id: "wr3",
            catId: "cat1",
            weight: 5.4,
            date: Calendar.current.date(from: DateComponents(year: 2023, month: 7, day: 1))!,
            notes: nil
        ),
        WeightRecord(
            id: "wr4",
            catId: "cat1",
            weight: 5.5,
            date: Calendar.current.date(from: DateComponents(year: 2023, month: 6, day: 1))!,
            notes: nil
        ),
        WeightRecord(
            id: "wr5",
            catId: "cat1",
            weight: 5.6,
            date: Calendar.current.date(from: DateComponents(year: 2023, month: 5, day: 1))!,
            notes: nil
        ),
        WeightRecord(
            id: "wr6",
            catId: "cat1",
            weight: 5.7,
            date: Calendar.current.date(from: DateComponents(year: 2023, month: 4, day: 1))!,
            notes: nil
        ),
        WeightRecord(
            id: "wr7",
            catId: "cat1",
            weight: 5.8,
            date: Calendar.current.date(from: DateComponents(year: 2023, month: 3, day: 1))!,
            notes: nil
        ),
        WeightRecord(
            id: "wr8",
            catId: "cat1",
            weight: 5.9,
            date: Calendar.current.date(from: DateComponents(year: 2023, month: 2, day: 1))!,
            notes: nil
        ),
        WeightRecord(
            id: "wr9",
            catId: "cat1",
            weight: 6.0,
            date: Calendar.current.date(from: DateComponents(year: 2023, month: 1, day: 1))!,
            notes: nil
        )
    ]
}
