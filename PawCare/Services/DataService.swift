import Foundation
import Combine

class DataService: ObservableObject {
    @Published var cats: [Cat] = []
    @Published var healthRecords: [HealthRecord] = []
    @Published var weightRecords: [WeightRecord] = []
    @Published var isLoading = false
    @Published var error: String?
    
    init() {
        // Load sample data for demo
        loadSampleData()
    }
    
    private func loadSampleData() {
        cats = [Cat.sample]
        healthRecords = HealthRecord.samples
        weightRecords = WeightRecord.samples
    }
    
    // MARK: - Cat Methods
    
    func addCat(_ cat: Cat) {
        cats.append(cat)
    }
    
    func updateCat(_ cat: Cat) {
        if let index = cats.firstIndex(where: { $0.id == cat.id }) {
            cats[index] = cat
        }
    }
    
    func deleteCat(id: String) {
        cats.removeAll { $0.id == id }
        // Also remove related records
        healthRecords.removeAll { $0.catId == id }
        weightRecords.removeAll { $0.catId == id }
    }
    
    func getCat(id: String) -> Cat? {
        return cats.first { $0.id == id }
    }
    
    // MARK: - Health Record Methods
    
    func addHealthRecord(_ record: HealthRecord) {
        healthRecords.append(record)
    }
    
    func updateHealthRecord(_ record: HealthRecord) {
        if let index = healthRecords.firstIndex(where: { $0.id == record.id }) {
            healthRecords[index] = record
        }
    }
    
    func deleteHealthRecord(id: String) {
        healthRecords.removeAll { $0.id == id }
    }
    
    func getHealthRecords(catId: String) -> [HealthRecord] {
        return healthRecords.filter { $0.catId == catId }
    }
    
    func getHealthRecords(catId: String, type: HealthRecord.RecordType) -> [HealthRecord] {
        return healthRecords.filter { $0.catId == catId && $0.type == type }
    }
    
    // MARK: - Weight Record Methods
    
    func addWeightRecord(_ record: WeightRecord) {
        weightRecords.append(record)
        // Sort by date descending
        weightRecords.sort { $0.date > $1.date }
    }
    
    func updateWeightRecord(_ record: WeightRecord) {
        if let index = weightRecords.firstIndex(where: { $0.id == record.id }) {
            weightRecords[index] = record
            // Sort by date descending
            weightRecords.sort { $0.date > $1.date }
        }
    }
    
    func deleteWeightRecord(id: String) {
        weightRecords.removeAll { $0.id == id }
    }
    
    func getWeightRecords(catId: String) -> [WeightRecord] {
        return weightRecords.filter { $0.catId == catId }.sorted(by: { $0.date > $1.date })
    }
    
    func getLatestWeight(catId: String) -> WeightRecord? {
        return weightRecords.filter { $0.catId == catId }.sorted(by: { $0.date > $1.date }).first
    }
    
    func getWeightChange(catId: String) -> Double? {
        let catRecords = weightRecords.filter { $0.catId == catId }.sorted(by: { $0.date > $1.date })
        
        guard catRecords.count >= 2 else { return nil }
        
        let latest = catRecords[0].weight
        let previous = catRecords[1].weight
        
        return latest - previous
    }
}
