import Foundation

protocol CollectionsSortOptionPersistenceServiceProtocol {
    func saveSortOption(_ option: CollectionsSortOption)
    func getSortOption() -> CollectionsSortOption?
}

final class CollectionsSortOptionPersistenceService {
    
    private let userDefaults: UserDefaults
    private let sortOptionKey = "SortOptionKey"
    
    init(userDeafaults: UserDefaults = .standard) {
        self.userDefaults = userDeafaults
    }
    
    func saveSortOption(_ option: CollectionsSortOption) {
        let encoder = JSONEncoder()
        
        do {
            let encoded = try encoder.encode(option)
            userDefaults.set(encoded, forKey: sortOptionKey)
        } catch {
            print("Failed to save sort option: \(error)")
        }
    }
    
    func getSortOption() -> CollectionsSortOption? {
        guard let savedData = userDefaults.object(forKey: sortOptionKey) as? Data else { return nil }
    
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(CollectionsSortOption.self, from: savedData)
        } catch {
            print("Failed to load sort option: \(error)")
            return nil
        }
    }
}
extension CollectionsSortOptionPersistenceService: CollectionsSortOptionPersistenceServiceProtocol {}
