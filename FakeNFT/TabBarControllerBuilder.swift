import UIKit

struct TabBarControllerBuilder {

    static func collectionsCoordinator(shoppingCart: ShoppingCart) -> CollectionsCoordinator {
        let api: NftAPI = FakeNftAPI()
        let catalogueDataService: CollectionProviderProtocol = CollectionProvider(api: api)
        let collectionsNavController = UINavigationController()
        let collectionsCoordinator = CollectionsCoordinator(
            api: api,
            navigationController: collectionsNavController,
            dataService: catalogueDataService,
            shoppingCart: shoppingCart
        )
        collectionsCoordinator.start()
        return collectionsCoordinator
    }

    static func makeRootVC() -> UITabBarController {

        let nftApi: NftAPI = FakeNftAPI()

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

        // Profile:
        let profileService = ProfileServiceImpl(nftApi: nftApi)
        let settingsStorage = SettingsStorage()

        let profileViewModel = ProfileViewModelImpl(profileService: profileService, settingsStorage: settingsStorage)
                let profileVC = ProfileVC(viewModel: profileViewModel)

        let profileNavController = UINavigationController(
            rootViewController: profileVC,
            title: "Профиль",
            imageName: "person.crop.circle.fill"
        )

        // Catalogue
        let catalogueNavController = collectionsCoordinator(shoppingCart: shoppingCart).navigationController
        catalogueNavController.tabBarItem = UITabBarItem(
            title: "Каталог",
            image: UIImage(systemName: "rectangle.stack.fill"),
            tag: 1
        )
        // Cart
        let cartNavController = UINavigationController(
            rootViewController: cartView,
            title: "Корзина",
            imageName: "bag.fill"
        )
        purchaseCoordinator.navigationController = cartNavController

        let tabBarController = UITabBarController()
        purchaseCoordinator.tabBarController = tabBarController

        tabBarController.viewControllers = [
            profileNavController,
            catalogueNavController,
            cartNavController]
        tabBarController.selectedIndex = 1

        tabBarController.tabBar.backgroundColor = .asset(.additional(.white))
        tabBarController.tabBar.tintColor = .asset(.additional(.blue))
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.standardAppearance = tabBarAppearance

        return tabBarController
    }

    private static var tabBarAppearance: UITabBarAppearance {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .asset(.additional(.white))
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = .asset(.main(.primary))
        tabBarAppearance.shadowImage = nil
        tabBarAppearance.shadowColor = nil
        return tabBarAppearance
    }
}

extension UINavigationController {
    convenience init(rootViewController: UIViewController, title: String, imageName: String) {
        self.init(rootViewController: rootViewController)
        self.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: imageName), tag: 0)
    }
}
