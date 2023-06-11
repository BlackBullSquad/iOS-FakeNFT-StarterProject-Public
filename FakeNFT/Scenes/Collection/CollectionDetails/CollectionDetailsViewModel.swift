import Foundation

final class CollectionDetailsViewModel {
    
    let collectionID: Int
    var errorMessage: Error?
    
    var viewModel: CollectionDetailsCellViewModel?
    weak var coordinator: CollectionsCoordinatorProtocol?
    private let dataService: CollectionProviderProtocol
    private let loadingService: LoadingHUDServiceProtocol
    
    init(
        dataService: CollectionProviderProtocol,
        coordinator: CollectionsCoordinatorProtocol?,
        collectionID: Int
    ) {
        self.dataService = dataService
        self.coordinator = coordinator
        self.collectionID = collectionID
        self.loadingService = LoadingHUDService.shared
    }
    
    // MARK: - Public methods
    
    func didLoadCollection(with id: Int, completion: @escaping () -> Void) {
        
        loadingService.showLoading()
        
        
        dataService.getCollection(id: id) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.loadingService.hideLoading()
                
                switch result {
                case .success(let collection):
                    self.viewModel = self.convertToViewModel(from: collection)
                    completion()
                    
                case .failure(let error):
                    self.errorMessage = error
                    completion()
                    
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func handleAuthorLinkTap(url: URL) {
        coordinator?.openAuthorLink(url: url)
    }
    
    private func convertToViewModel(from collection: Collection) -> CollectionDetailsCellViewModel {
        return CollectionDetailsCellViewModel(collection) { [weak self] url in
            self?.handleAuthorLinkTap(url: url)
        }
    }
}
