import Foundation

protocol CatalogueViewModelUpdateListener: AnyObject {
    func didUpdateCollections()
    func didFailWithError(_ error: Error)
}

final class CatalogueViewModel {
    
    private let dataService: CollectionProviderProtocol
    var viewModels: [CatalogueCellViewModel]?
    
    weak var updateListener: CatalogueViewModelUpdateListener?
    
    init(dataService: CollectionProviderProtocol) {
        self.dataService = dataService
    }
    
    func loadCollections() {
        dataService.getCollections { [weak self] result in
            switch result {
            case .success(let collection):
                DispatchQueue.main.async {
                    self?.viewModels = collection.map { CatalogueCellViewModel($0) }
                    self?.updateListener?.didUpdateCollections()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.updateListener?.didFailWithError(error)
                }
            }
        }
    }

    enum SortOption {
        case byName
        case byNftCount
    }
    
    func sortModels(_ option: SortOption) {
        
        guard var viewModels = viewModels, let updateListener = updateListener else { return }
        
        switch option {
        case .byName:
            viewModels.sort { $0.title < $1.title }
        case .byNftCount:
            viewModels.sort { $0.nftsCount > $1.nftsCount }
        }
        
        self.viewModels = viewModels
        updateListener.didUpdateCollections()
    }
}
