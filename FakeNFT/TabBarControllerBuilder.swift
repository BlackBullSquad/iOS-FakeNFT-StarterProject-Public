import UIKit

struct TabBarControllerBuilder {
    
    static var collectionsCoordinator: CollectionsCoordinator = {
        let api: NftAPI = FakeNftAPI()
        let catalogueDataService: CollectionProviderProtocol = CollectionProvider(api: api)
        let collectionsNavController = UINavigationController()
        let collectionsCoordinator = CollectionsCoordinator(
            api: api,
            navigationController: collectionsNavController,
            dataService: catalogueDataService
        )
        collectionsCoordinator.start()
        return collectionsCoordinator
    }()

    static func makeRootVC() -> UITabBarController {
        let profileVC = ProfileVC()
        let profileNavController = UINavigationController(rootViewController: profileVC, title: "Профиль", imageName: "person.crop.circle.fill")
        
        let catalogueNavController = collectionsCoordinator.navigationController
        catalogueNavController.tabBarItem = UITabBarItem(
            title: "Каталог",
            image: UIImage(systemName: "rectangle.stack.fill"),
            tag: 1
        )

        let cartVC = CartVC()
        let cartNavController = UINavigationController(rootViewController: cartVC, title: "Корзина", imageName: "bag.fill")

        let tabBarController = UITabBarController()
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
