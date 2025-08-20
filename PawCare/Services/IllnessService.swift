import Foundation
import Combine

final class IllnessService: ObservableObject {
    @Published var predefinedIllnesses: [Illness] = Illness.predefinedIllnesses
    @Published var customIllnesses: [Illness] = []

    func getAll() -> [Illness] { predefinedIllnesses + customIllnesses }

    func addCustom(_ illness: Illness, completion: @escaping (Result<Illness, Error>) -> Void) {
        guard !illness.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            completion(.failure(NSError(domain: "PawCare", code: 400, userInfo: [NSLocalizedDescriptionKey: "Illness name cannot be empty"])) )
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.customIllnesses.append(illness)
            completion(.success(illness))
        }
    }

    func updateCustom(_ illness: Illness, completion: @escaping (Result<Illness, Error>) -> Void) {
        guard let index = customIllnesses.firstIndex(where: { $0.id == illness.id }) else {
            completion(.failure(NSError(domain: "PawCare", code: 404, userInfo: [NSLocalizedDescriptionKey: "Custom illness not found"])) )
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.customIllnesses[index] = illness
            completion(.success(illness))
        }
    }

    func deleteCustom(_ illness: Illness, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.customIllnesses.removeAll { $0.id == illness.id }
            completion(.success(()))
        }
    }
}
