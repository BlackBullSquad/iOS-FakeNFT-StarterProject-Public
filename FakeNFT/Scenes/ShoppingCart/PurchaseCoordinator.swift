import UIKit

protocol Coordinator {
    func start()
}

final class PurchaseCoordinator: Coordinator {
    weak var navigationController: UINavigationController?

    func start() {
        print("LETSGOOOOO")
    }
}
