import Foundation
import Combine

final class PetService: ObservableObject {
    static let shared = PetService()

    @Published var pets: [Pet] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func addPet(_ pet: Pet, completion: @escaping (Result<Pet, Error>) -> Void) {
        guard !pet.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            completion(.failure(NSError(domain: "PawCare", code: 400, userInfo: [NSLocalizedDescriptionKey: "Pet name cannot be empty"])) )
            return
        }
        guard pet.age > 0 else {
            completion(.failure(NSError(domain: "PawCare", code: 400, userInfo: [NSLocalizedDescriptionKey: "Pet age must be greater than 0"])) )
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.pets.append(pet)
            completion(.success(pet))
        }
    }

    func updatePet(_ pet: Pet, completion: @escaping (Result<Pet, Error>) -> Void) {
        guard let index = pets.firstIndex(where: { $0.id == pet.id }) else {
            completion(.failure(NSError(domain: "PawCare", code: 404, userInfo: [NSLocalizedDescriptionKey: "Pet not found"])) )
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.pets[index] = pet
            completion(.success(pet))
        }
    }

    func deletePet(_ pet: Pet, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.pets.removeAll { $0.id == pet.id }
            completion(.success(()))
        }
    }

    func getAllPets(completion: @escaping (Result<[Pet], Error>) -> Void) {
        DispatchQueue.main.async { completion(.success(self.pets)) }
    }
}
