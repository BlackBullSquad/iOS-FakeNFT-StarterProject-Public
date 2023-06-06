import UIKit

struct TabBarControllerBuilder {
    
    static var collectionsCoordinator: CollectionsCoordinator?

    static func makeRootVC() -> UITabBarController? {
        let api: NftAPI = FakeNftAPI()
        let catalogueDataService: CollectionProviderProtocol = CollectionProvider(api: api)
        
        // MARK: - View Controllers
        let profileVC = ProfileVC()

        let collectionsNavController = UINavigationController()
        collectionsCoordinator = CollectionsCoordinator(
            api: api,
            navigationController: collectionsNavController,
            dataService: catalogueDataService
        )
        collectionsCoordinator?.start()

        guard let collectionsCoordinator = collectionsCoordinator else {
            return nil
        }
        
        let cartVC = CartVC()

        // MARK: - Navigation Controllers
        let profileNavController = createNavigationController(
            with: profileVC,
            title: "Профиль",
            imageName: "person.crop.circle.fill"
        )
        let catalogueNavController = collectionsCoordinator.navigationController
        catalogueNavController.tabBarItem = UITabBarItem(
            title: "Каталог",
            image: UIImage(systemName: "rectangle.stack.fill"),
            tag: 1
        )
            
        let cartNavController = createNavigationController(
            with: cartVC,
            title: "Корзина",
            imageName: "bag.fill"
        )

        // MARK: - Tab Bar Controller
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            profileNavController,
            catalogueNavController,
            cartNavController]
        tabBarController.selectedIndex = 1
        tabBarController.tabBar.backgroundColor = .asset(.main(.lightGray))
        tabBarController.tabBar.tintColor = .asset(.main(.primary))

        return tabBarController
    }


    private static func createNavigationController(with rootController: UIViewController, title: String, imageName: String) -> UINavigationController {

        let navigationController = UINavigationController(rootViewController: rootController)
        navigationController.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: imageName), tag: 0)

        return navigationController
    }

}
