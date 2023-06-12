import UIKit

protocol CollectionsCoordinatorProtocol: AnyObject {
    func start()
    func openCollectionDetail(withId id: Int)
    func openAuthorLink(url: URL)
    func goBack()
}

final class CollectionsCoordinator {
   
    var navigationController: UINavigationController
    private let api: NftAPI
    private let dataService: CollectionProviderProtocol
    private let shoppingCartService: ShoppingCart

    init(api: NftAPI, navigationController: UINavigationController, dataService: CollectionProviderProtocol) {
        self.api = api
        self.navigationController = navigationController
        self.dataService = dataService
        self.shoppingCartService = FakeShoppingCart()
    }

    func start() {
        let catalogueViewModel = CatalogueViewModel(dataService: dataService, coordinator: self)
        let catalogueViewController = CatalogueView(viewModel: catalogueViewModel)
        navigationController.viewControllers = [catalogueViewController]
    }
    
    func openCollectionDetail(withId id: Int) {
        let collectionViewModel = CollectionDetailsViewModel(
            dataService: dataService,
            coordinator: self,
            collectionID: id,
            shoppingCartService: shoppingCartService
        )
        let collectionViewController = CollectionDetailsView(viewModel: collectionViewModel)
        collectionViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(collectionViewController, animated: true)
    }
    
    func openAuthorLink(url: URL) {
        let webViewController = WebView(url: url)
        webViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(webViewController, animated: true)
    }
    
    func goBack() {
        navigationController.popViewController(animated: true)
    }
}

extension CollectionsCoordinator: CollectionsCoordinatorProtocol {}
