import Foundation
import Combine

class DataService: ObservableObject {
    @Published var cats: [Cat] = []
    @Published var healthRecords: [HealthRecord] = []
    @Published var weightRecords: [WeightRecord] = []
    @Published var isLoading = false
    @Published var error: String?
    
    // MARK: - Backend Integration Placeholders
    
    /// Backend API base URL
    private let apiBaseURL = "https://api.pawcare.example.com"
    
    /// API endpoints
    private enum Endpoint {
        static let cats = "/cats"
        static let healthRecords = "/health-records"
        static let weightRecords = "/weight-records"
    }
    
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
        
        // MARK: Backend Integration
        // In a real app, you would make an API call to your backend
        /*
        guard let url = URL(string: apiBaseURL + Endpoint.cats) else {
            self.error = "Invalid API URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(cat)
        } catch {
            self.error = "Failed to encode request"
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.error = error.localizedDescription
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.error = "Invalid response"
                    return
                }
                
                if httpResponse.statusCode == 201, let data = data {
                    do {
                        let newCat = try JSONDecoder().decode(Cat.self, from: data)
                        self.cats.append(newCat)
                    } catch {
                        self.error = "Failed to decode response"
                    }
                } else {
                    self.error = "Failed to add cat: \(httpResponse.statusCode)"
                }
            }
        }.resume()
        */
    }
    
    func updateCat(_ cat: Cat) {
        if let index = cats.firstIndex(where: { $0.id == cat.id }) {
            cats[index] = cat
        }
        
        // MARK: Backend Integration
        // In a real app, you would make an API call to your backend
        /*
        guard let url = URL(string: apiBaseURL + Endpoint.cats + "/\(cat.id)") else {
            self.error = "Invalid API URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(cat)
        } catch {
            self.error = "Failed to encode request"
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.error = error.localizedDescription
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.error = "Invalid response"
                    return
                }
                
                if httpResponse.statusCode == 200, let data = data {
                    do {
                        let updatedCat = try JSONDecoder().decode(Cat.self, from: data)
                        if let index = self.cats.firstIndex(where: { $0.id == updatedCat.id }) {
                            self.cats[index] = updatedCat
                        }
                    } catch {
                        self.error = "Failed to decode response"
                    }
                } else {
                    self.error = "Failed to update cat: \(httpResponse.statusCode)"
                }
            }
        }.resume()
        */
    }
    
    func deleteCat(id: String) {
        cats.removeAll { $0.id == id }
        // Also remove related records
        healthRecords.removeAll { $0.catId == id }
        weightRecords.removeAll { $0.catId == id }
        
        // MARK: Backend Integration
        // In a real app, you would make an API call to your backend
        /*
        guard let url = URL(string: apiBaseURL + Endpoint.cats + "/\(id)") else {
            self.error = "Invalid API URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.error = error.localizedDescription
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.error = "Invalid response"
                    return
                }
                
                if httpResponse.statusCode == 204 {
                    self.cats.removeAll { $0.id == id }
                    self.healthRecords.removeAll { $0.catId == id }
                    self.weightRecords.removeAll { $0.catId == id }
                } else {
                    self.error = "Failed to delete cat: \(httpResponse.statusCode)"
                }
            }
        }.resume()
        */
    }
    
    func getCat(id: String) -> Cat? {
        return cats.first { $0.id == id }
    }
    
    // MARK: - Health Record Methods
    
    func addHealthRecord(_ record: HealthRecord) {
        healthRecords.append(record)
        
        // MARK: Backend Integration
        // In a real app, you would make an API call to your backend
        /*
        guard let url = URL(string: apiBaseURL + Endpoint.healthRecords) else {
            self.error = "Invalid API URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(record)
        } catch {
            self.error = "Failed to encode request"
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.error = error.localizedDescription
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.error = "Invalid response"
                    return
                }
                
                if httpResponse.statusCode == 201, let data = data {
                    do {
                        let newRecord = try JSONDecoder().decode(HealthRecord.self, from: data)
                        self.healthRecords.append(newRecord)
                    } catch {
                        self.error = "Failed to decode response"
                    }
                } else {
                    self.error = "Failed to add health record: \(httpResponse.statusCode)"
                }
            }
        }.resume()
        */
    }
    
    func updateHealthRecord(_ record: HealthRecord) {
        if let index = healthRecords.firstIndex(where: { $0.id == record.id }) {
            healthRecords[index] = record
        }
        
        // MARK: Backend Integration
        // In a real app, you would make an API call to your backend
    }
    
    func deleteHealthRecord(id: String) {
        healthRecords.removeAll { $0.id == id }
        
        // MARK: Backend Integration
        // In a real app, you would make an API call to your backend
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
        
        // MARK: Backend Integration
        // In a real app, you would make an API call to your backend
    }
    
    func updateWeightRecord(_ record: WeightRecord) {
        if let index = weightRecords.firstIndex(where: { $0.id == record.id }) {
            weightRecords[index] = record
            // Sort by date descending
            weightRecords.sort { $0.date > $1.date }
        }
        
        // MARK: Backend Integration
        // In a real app, you would make an API call to your backend
    }
    
    func deleteWeightRecord(id: String) {
        weightRecords.removeAll { $0.id == id }
        
        // MARK: Backend Integration
        // In a real app, you would make an API call to your backend
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
    
    // MARK: - Fetch Data from Backend
    
    func fetchCats() {
        isLoading = true
        
        // MARK: Backend Integration
        // In a real app, you would make an API call to your backend
        /*
        guard let url = URL(string: apiBaseURL + Endpoint.cats) else {
            self.error = "Invalid API URL"
            self.isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let error = error {
                    self.error = error.localizedDescription
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.error = "Invalid response"
                    return
                }
                
                if httpResponse.statusCode == 200, let data = data {
                    do {
                        self.cats = try JSONDecoder().decode([Cat].self, from: data)
                    } catch {
                        self.error = "Failed to decode response"
                    }
                } else {
                    self.error = "Failed to fetch cats: \(httpResponse.statusCode)"
                }
            }
        }.resume()
        */
        
        // For demo, we'll just simulate a network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
        }
    }
    
    func fetchHealthRecords(catId: String) {
        isLoading = true
        
        // MARK: Backend Integration
        // In a real app, you would make an API call to your backend
        
        // For demo, we'll just simulate a network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
        }
    }
    
    func fetchWeightRecords(catId: String) {
        isLoading = true
        
        // MARK: Backend Integration
        // In a real app, you would make an API call to your backend
        
        // For demo, we'll just simulate a network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
        }
    }
}