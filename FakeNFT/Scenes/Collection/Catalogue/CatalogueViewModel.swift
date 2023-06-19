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
    private let sortStateService: CollectionsSortPersistence
    private let loadingService: LoadingHUDServiceProtocol

    weak var coordinator: CollectionsCoordinatorProtocol?
    weak var updateListener: CatalogueViewModelUpdateListener?

    var viewModels: [CatalogueCellViewModel]?

    init(
        dataService: CollectionProviderProtocol,
        sortStateService: CollectionsSortPersistence = CollectionsSortPersistenceService(),
        coordinator: CollectionsCoordinatorProtocol?
    ) {
        self.dataService = dataService
        self.sortStateService = sortStateService
        self.coordinator = coordinator
        self.loadingService = LoadingHUDService.shared
    }

    // MARK: - Public methods

    func didLoadCollections() {

        loadingService.showLoading()

        dataService.getCollections { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.loadingService.hideLoading()

                switch result {
                case .success(let collection):
                    self.viewModels = collection.map { CatalogueCellViewModel($0) }

                    let sortOption = self.loadSortOption()
                    self.sortModels(sortOption)

                    self.updateListener?.didUpdateCollections()
                case .failure(let error):
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

    func didSelectItem(at id: Int) {
        coordinator?.openCollectionDetail(withId: id)
    }

    // MARK: - Private methods

    private func loadSortOption() -> CollectionsSortOption {
        return sortStateService.getSortOption() ?? .byName
    }
}
