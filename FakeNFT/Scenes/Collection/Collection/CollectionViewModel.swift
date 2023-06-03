import Foundation

final class CollectionViewModel {
    
    private let dataService: CollectionProviderProtocol
    private let collectionID: Int
    
    init(
        dataService: CollectionProviderProtocol,
        collectionID: Int
    ) {
        self.dataService = dataService
        self.collectionID = collectionID
        print(collectionID)
    }
}
