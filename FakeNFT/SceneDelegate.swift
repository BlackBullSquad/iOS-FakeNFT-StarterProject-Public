import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // MARK: - View Controllers
        
        let profileVC = ProfileVC()
        let catalogueVC = CatalogueVC()
        let cartVC = CartVC()
        
        // MARK: - Navigation Controllers
        
        let profileNavController = createNavigationController(with: profileVC, title: "Профиль", imageName: "person.crop.circle.fill")
        let catalogueNavController = createNavigationController(with: catalogueVC, title: "Каталог", imageName: "rectangle.stack.fill")
        let cartNavController = createNavigationController(with: cartVC, title: "Корзина", imageName: "bag.fill")
        
        // MARK: - Tab Bar Controller
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [profileNavController, catalogueNavController, cartNavController]
        tabBarController.selectedIndex = 1
        tabBarController.tabBar.backgroundColor = .appColor(.lightGray)
        tabBarController.tabBar.tintColor = .appColor(.primary)
        
        // MARK: - Window Configuration
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    // MARK: - Private Helpers
    
    private func createNavigationController(with rootViewController: UIViewController, title: String, imageName: String) -> UINavigationController {
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: imageName), tag: 0)
        
        return navigationController
    }
}
