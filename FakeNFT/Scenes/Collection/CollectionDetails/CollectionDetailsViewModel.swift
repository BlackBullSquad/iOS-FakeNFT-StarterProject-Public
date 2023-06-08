import Foundation

final class CollectionDetailsViewModel {
    
    private let dataService: CollectionProviderProtocol
    let collectionID: Int
    
    weak var coordinator: CollectionsCoordinatorProtocol?
    
    var viewModel: CollectionDetailsCellViewModel?
    
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
    
    // MARK: - Private Methods
    
    private func handleAuthorLinkTap(url: URL) {
        print("Hello Cell I see you. CollectionViewModel")
        coordinator?.openAuthorLink(url: url)
    }

    private func convertToViewModel(from collection: Collection) -> CollectionDetailsCellViewModel {
        return CollectionDetailsCellViewModel(collection) { [weak self] url in
            self?.handleAuthorLinkTap(url: url)
        }
    }
}
