import Foundation
import Combine

final class PetViewModel: ObservableObject {
    @Published var pets: [Pet] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    private let service = PetService.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        service.$pets.receive(on: RunLoop.main).assign(to: &self.$pets)
    }

    func loadPets() {
        isLoading = true
        service.getAllPets { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data): self?.pets = data
                case .failure(let error): self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func add(pet: Pet) { service.addPet(pet) { _ in } }
    func update(pet: Pet) { service.updatePet(pet) { _ in } }
    func delete(pet: Pet) { service.deletePet(pet) { _ in } }
}
