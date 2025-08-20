import Foundation
import Combine

final class IllnessViewModel: ObservableObject {
    @Published var illnesses: [Illness] = []
    @Published var errorMessage: String?

    private let service = IllnessService()

    func load() {
        illnesses = service.getAll()
    }

    func addCustom(name: String, description: String, category: Illness.IllnessCategory) {
        let illness = Illness(name: name, icon: category.icon, description: description, isPredefined: false, category: category)
        service.addCustom(illness) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success: self?.illnesses = self?.service.getAll() ?? []
                case .failure(let error): self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
