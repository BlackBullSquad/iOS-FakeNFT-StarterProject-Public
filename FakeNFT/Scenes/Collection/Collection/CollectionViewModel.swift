import Foundation

final class CollectionViewModel {
    
    private let dataService: CollectionProviderProtocol
    let collectionID: Int
    
    weak var coordinator: CollectionsCoordinatorProtocol?
    
    var viewModel: CollectionCellViewModel?
    
    init(
        dataService: CollectionProviderProtocol,
        coordinator: CollectionsCoordinatorProtocol?,
        collectionID: Int
    ) {
        self.dataService = dataService
        self.coordinator = coordinator
        self.collectionID = collectionID
        print(collectionID)
    }
    
    // MARK: - Public methods
    
    func loadCollection(with id: Int, completion: @escaping () -> Void) {
        dataService.getCollection(id: id) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let collection):
                DispatchQueue.main.async {
                    self.viewModel = self.convertToViewModel(from: collection)
                    completion()
                }
            case .failure(let error):
                assertionFailure("\(error)")
            }
        }
    }

    private func convertToViewModel(from collection: Collection) -> CollectionCellViewModel {
        return .init(collection)
    }
    
}
