import Foundation

enum CollectionsSortOption: String, Codable {
    case byName
    case byNftCount
}

protocol CatalogueViewModelUpdateListener: AnyObject {
    func didUpdateCollections()
    func didFailWithError(_ error: Error)
}

final class CatalogueViewModel {
    
    private let dataService: CollectionProviderProtocol
    private let sortStateService: CollectionsSortOptionPersistenceServiceProtocol

    weak var coordinator: CollectionsCoordinatorProtocol?
    weak var updateListener: CatalogueViewModelUpdateListener?
    
    var viewModels: [CatalogueCellViewModel]?
    
    init(
        dataService: CollectionProviderProtocol,
        sortStateService: CollectionsSortOptionPersistenceServiceProtocol = CollectionsSortOptionPersistenceService(),
        coordinator: CollectionsCoordinatorProtocol?
    ) {
        self.dataService = dataService
        self.sortStateService = sortStateService
        self.coordinator = coordinator
    }

    // MARK: - Public methods
    
    func loadCollections() {
        dataService.getCollections { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let collection):
                DispatchQueue.main.async {
                    self.viewModels = collection.map { CatalogueCellViewModel($0) }
                    
                    let sortOption = self.loadSortOption()
                    self.sortModels(sortOption)

                    self.updateListener?.didUpdateCollections()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.updateListener?.didFailWithError(error)
                }
            }
        }
    }
    
    func sortModels(_ option: CollectionsSortOption) {
        guard var viewModels = viewModels, let updateListener = updateListener else { return }
        
        switch option {
        case .byName:
            viewModels.sort { $0.title < $1.title }
        case .byNftCount:
            viewModels.sort { $0.nftsCount > $1.nftsCount }
        }
        
        self.viewModels = viewModels
        updateListener.didUpdateCollections()
        sortStateService.saveSortOption(option)
    }
    
    // MARK: - Private methods

    private func loadSortOption() -> CollectionsSortOption {
        return sortStateService.getSortOption() ?? .byName
    }
}
