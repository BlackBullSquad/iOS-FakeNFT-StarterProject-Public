import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let profileVC = ProfileVC()
        let catalogueVC = CatalogueVC()
        let cartVC = CartVC()
        
        let profileNavController = UINavigationController(rootViewController: profileVC)
        let catalogueNavController = UINavigationController(rootViewController: catalogueVC)
        let cartNavController = UINavigationController(rootViewController: cartVC)
    
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            profileNavController,
            catalogueNavController,
            cartNavController
        ]
        tabBarController.selectedIndex = 1
        tabBarController.tabBar.backgroundColor = UIColor.lightGray
        tabBarController.tabBar.tintColor = UIColor.primary
        
        profileNavController.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person.crop.circle.fill"), tag: 0)
        catalogueNavController.tabBarItem = UITabBarItem(title: "Каталог", image: UIImage(systemName: "rectangle.stack.fill"), tag: 1)
        cartNavController.tabBarItem = UITabBarItem(title: "Корзина", image: UIImage(systemName: "bag.fill"), tag: 2)
    
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }
}
