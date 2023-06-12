import Foundation

final class CollectionDetailsViewModel {
    
    let collectionID: Int
    var errorMessage: Error?
    
    var coverAndDescriptionCellsViewModel: CoverAndDescriptionCellsViewModel?
    var nftListViewModel: NftListViewModel?
    
    weak var coordinator: CollectionsCoordinatorProtocol?
    
    private let dataService: CollectionProviderProtocol
    private let loadingService: LoadingHUDServiceProtocol
    private let shoppingCartService: ShoppingCart
    
    init(
        dataService: CollectionProviderProtocol,
        coordinator: CollectionsCoordinatorProtocol?,
        collectionID: Int,
        shoppingCartService: ShoppingCart
    ) {
        self.dataService = dataService
        self.coordinator = coordinator
        self.collectionID = collectionID
        self.loadingService = LoadingHUDService.shared
        self.shoppingCartService = shoppingCartService
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
                    self.coverAndDescriptionCellsViewModel = self.convertToCoverAndDescriptionCellsViewModel(from: collection)
                    self.nftListViewModel = NftListViewModel(nfts: collection.nfts, shoppingCart: self.shoppingCartService)
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
    
    private func convertToCoverAndDescriptionCellsViewModel(from collection: Collection) -> CoverAndDescriptionCellsViewModel {
        return CoverAndDescriptionCellsViewModel(collection) { [weak self] url in
            self?.handleAuthorLinkTap(url: url)
        }
    }
}
