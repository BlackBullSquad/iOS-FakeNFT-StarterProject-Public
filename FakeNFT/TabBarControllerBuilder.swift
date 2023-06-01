import UIKit

struct TabBarControllerBuilder {

    static func makeRootVC() -> UITabBarController {

        // MARK: - View Controllers
        let profileVC = ProfileVC()
        let catalogueVC = CatalogueVC()

        let api = FakeNftAPI()
        let purchaseCoordinator = PurchaseCoordinator(deps: .init(
            currencyProvider: FakeCurrencyProvider(api: api)
        ))
        let cartVC = ShoppingCartController(deps: .init(
            nftProvider: FakeNftProvider(api: api),
            shoppingCart: FakeShoppingCart()
        )) {
            purchaseCoordinator.start()
        }

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
            with: cartVC,
            title: "Корзина",
            imageName: "bag.fill"
        )
        purchaseCoordinator.navigationController = cartNavController

        // MARK: - Tab Bar Controller
        let tabBarController = UITabBarController()
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
