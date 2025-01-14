import Foundation

final class CollectionDetailsViewModel {

    let collectionID: Int
    var errorMessage: Error?

    var coverCellViewModel: CoverCellViewModel?
    var descriptionCellViewModel: DescriptionCellViewModel?
    var nftListViewModel: NftListViewModel?

    weak var coordinator: CollectionsCoordinatorProtocol?

    // Mock user ID
    private let userID: Int = 1

    private let dataService: CollectionProviderProtocol
    private let loadingService: LoadingHUDServiceProtocol
    private let shoppingCartService: ShoppingCart
    private let likeService: NftLikesProviderProtocol

    init(
        dataService: CollectionProviderProtocol,
        coordinator: CollectionsCoordinatorProtocol?,
        collectionID: Int,
        shoppingCartService: ShoppingCart,
        likeService: NftLikesProviderProtocol
    ) {
        self.dataService = dataService
        self.coordinator = coordinator
        self.collectionID = collectionID
        self.loadingService = LoadingHUDService.shared
        self.shoppingCartService = shoppingCartService
        self.likeService = likeService
    }

    // MARK: - Public methods

    func didLoadCollection(with id: Int, completion: @escaping () -> Void) {

        loadingService.showLoading() // Show ProgressHUD

        let dispatchGroup = DispatchGroup()

        var fetchedCollection: Collection?
        var fetchedLikes: [Int] = []

        // Fetch collection
        fetchCollection(id: id, dispatchGroup: dispatchGroup) { collection in
            fetchedCollection = collection
        }

        // Fetch likes
        fetchLikes(dispatchGroup: dispatchGroup) { likes in
            fetchedLikes = likes
        }

        // Notify when all requests are done
        dispatchGroup.notify(queue: .main) {
            self.loadingService.hideLoading() // Hide ProgressHUD

            if let collection = fetchedCollection {
                self.processFetchedData(collection: collection, likes: fetchedLikes)
            }

            completion()
        }
    }

    // MARK: - Private Methods

    private func fetchCollection(id: Int, dispatchGroup: DispatchGroup, completion: @escaping (Collection?) -> Void) {
        dispatchGroup.enter()
        dataService.getCollection(id: id) { result in
            defer { dispatchGroup.leave() }

            switch result {
            case .success(let collection):
                completion(collection)
            case .failure:
                completion(nil)
            }
        }
    }

    private func fetchLikes(dispatchGroup: DispatchGroup, completion: @escaping ([Int]) -> Void) {
        dispatchGroup.enter()
        likeService.getLikes(userID: userID) { result in
            defer { dispatchGroup.leave() }

            if case .success(let likes) = result {
                completion(likes)
            } else {
                completion([])
            }
        }
    }

    private func processFetchedData(collection: Collection, likes: [Int]) {
        self.coverCellViewModel = self.convertToCoverCellViewModel(from: collection)
        self.descriptionCellViewModel = self.convertToDescriptionCellViewModel(from: collection)

        self.nftListViewModel = NftListViewModel(
            nfts: collection.nfts,
            fetchedLikes: likes,
            shoppingCart: self.shoppingCartService,
            updateLikesAction: { [weak self] likes in
                self?.likeService.updateLikes(userID: self?.userID ?? 0, likes: likes) { result in
                    switch result {
                    case .success:
                        LogService.shared.log("Likes updated successfully.", level: .info)
                    case .failure(let error):
                        LogService.shared.log("Failed to update likes: \(error).", level: .error)
                        self?.errorMessage = error
                    }
                }
            }
        )
    }

    private func handleAuthorLinkTap(url: URL) {
        coordinator?.openAuthorLink(url: url)
    }

    private func convertToCoverCellViewModel(from collection: Collection) -> CoverCellViewModel {
        return CoverCellViewModel(collection)
    }

    private func convertToDescriptionCellViewModel(from collection: Collection) -> DescriptionCellViewModel {
        return DescriptionCellViewModel(collection) { [weak self] url in
            self?.handleAuthorLinkTap(url: url)
        }
    }
}
