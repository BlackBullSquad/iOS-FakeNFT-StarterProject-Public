import UIKit

protocol CollectionsCoordinatorProtocol: AnyObject {
    func start()
    func openCollectionDetail(withId id: Int)
    func openAuthorLink(url: URL)
}

final class CollectionsCoordinator {
   
    var navigationController: UINavigationController
    private let api: NftAPI
    private let dataService: CollectionProviderProtocol

    init(api: NftAPI, navigationController: UINavigationController, dataService: CollectionProviderProtocol) {
        self.api = api
        self.navigationController = navigationController
        self.dataService = dataService
    }

    func start() {
        let catalogueViewModel = CatalogueViewModel(dataService: dataService, coordinator: self)
        let catalogueViewController = CatalogueView(viewModel: catalogueViewModel)
        navigationController.viewControllers = [catalogueViewController]
    }
    
    func openCollectionDetail(withId id: Int) {
        let collectionViewModel = CollectionViewModel(
            dataService: dataService,
            coordinator: self,
            collectionID: id)
        let collectionViewController = CollectionView(viewModel: collectionViewModel)
        collectionViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(collectionViewController, animated: true)
    }
    
    func openAuthorLink(url: URL) {
        let webViewController = WebView(url: url)
        webViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(webViewController, animated: true)
    }
}

extension CollectionsCoordinator: CollectionsCoordinatorProtocol {}
