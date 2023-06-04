import UIKit

struct TabBarControllerBuilder {

    static func makeRootVC() -> UITabBarController {

        // MARK: - View Controllers
        let profileVC = ProfileVC()

        let api = FakeNftAPI()
        let shoppingCart = FakeShoppingCart(defaults: .standard)

        let purchaseCoordinator = PurchaseCoordinator(deps: .init(
            currencyProvider: FakeCurrencyProvider(api: api),
            shoppingCart: shoppingCart,
            paymentService: FakePaymentService(api: api)
        ))

        let cartViewModel = ShoppingCartViewModel(
            deps: .init(nftProvider: FakeNftProvider(api: api),
                        shoppingCart: shoppingCart),
            onPurchase: purchaseCoordinator.start
        )
        let cartView = ShoppingCartView(cartViewModel)

        let catalogueViewModel = CatalogueViewModel(dataService: CollectionProvider(api: api))
        let catalogueVC = CatalogueViewController(viewModel: catalogueViewModel)

        // MARK: - Navigation Controllers
        let profileNavController = createNavigationController(
            with: profileVC,
            title: "Профиль",
            imageName: "person.crop.circle.fill"
        )
        let catalogueNavController = createNavigationController(
            with: catalogueVC,
            title: "Каталог",
            imageName: "rectangle.stack.fill"
        )

        let cartNavController = createNavigationController(
            with: cartView,
            title: "Корзина",
            imageName: "bag.fill"
        )
        purchaseCoordinator.navigationController = cartNavController

        // MARK: - Tab Bar Controller
        let tabBarController = UITabBarController()
        purchaseCoordinator.tabBarController = tabBarController

        tabBarController.viewControllers = [
            profileNavController,
            catalogueNavController,
            cartNavController]
        tabBarController.selectedIndex = 1
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.tintColor = .asset(.main(.primary))

        return tabBarController
    }

    private static func createNavigationController(
        with rootController: UIViewController,
        title: String, imageName: String
    ) -> UINavigationController {

        let navigationController = UINavigationController(rootViewController: rootController)
        navigationController.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: imageName), tag: 0)

        return navigationController
    }

}
