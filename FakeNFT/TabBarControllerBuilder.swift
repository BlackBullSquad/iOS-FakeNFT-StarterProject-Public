import UIKit

struct TabBarControllerBuilder {

    static func makeRootVC() -> UITabBarController {

        let api: NftAPI = FakeNftAPI()
        
        // MARK: - View Controllers
        let profileVC = ProfileVC()

        let catalogueViewModel = CatalogueViewModel(dataService: CollectionProvider(api: api))
        let catalogueVC = CatalogueViewController(viewModel: catalogueViewModel)

        let cartVC = CartVC()

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
