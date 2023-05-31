import Foundation

protocol CatalogueViewModelUpdateListener: AnyObject {
    func didUpdateCollections()
    func didFailWithError(_ error: Error)
}

final class CatalogueViewModel {
    
    private let dataService: CollectionProvider
    var viewModels: [CatalogueVC.ViewModel]?
    
    weak var updateListener: CatalogueViewModelUpdateListener?
    
    init(dataService: CollectionProvider) {
        self.dataService = dataService
    }
    
    func loadCollections() {
        dataService.getCollections { result in
            switch result {
            case .success(let collection):
                DispatchQueue.main.async { [weak self] in
                    self?.viewModels = collection.map { CatalogueVC.ViewModel($0) }
                    self?.updateListener?.didUpdateCollections()
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.updateListener?.didFailWithError(error)
                }
            }
        }
    }

    enum SortOption {
        case byName
        case byNftCount
    }
    
    func sortModels(by option: SortOption) {
        switch option {
        case .byName:
            viewModels?.sort { $0.title < $1.title }
        case .byNftCount:
            viewModels?.sort { $0.nftsCount > $1.nftsCount }
        }
        updateListener?.didUpdateCollections()
    }
}
