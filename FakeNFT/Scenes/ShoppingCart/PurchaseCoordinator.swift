import UIKit

protocol Coordinator {
    func start()
}

final class PurchaseCoordinator {
    weak var navigationController: UINavigationController?
    weak var tabBarController: UITabBarController?

    let deps: Dependencies

    init(deps: Dependencies) {
        self.deps = deps
    }
}

extension PurchaseCoordinator {
    struct Dependencies {
        let currencyProvider: CurrencyProvider
        let shoppingCart: ShoppingCart
        let paymentService: PaymentService
    }
}

extension PurchaseCoordinator: Coordinator {
    func start() {
        displayCurrencySelector()
    }

    func displayCurrencySelector() {
        let viewModel = CurrencySelectViewModel(
            deps: .init(currencyProvider: deps.currencyProvider)
        ) { [weak self] id in
            self?.performPayment(with: id)
        }

        let currencyVC = CurrencySelectView(viewModel)

        navigationController?.pushViewController(currencyVC, animated: true)
    }

    func performPayment(with currencyId: Currency.ID) {
        deps.paymentService.pay(with: currencyId) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.displayPurchaseResult(isSuccess: result)
            }
        }
    }

    func displayPurchaseResult(isSuccess: Bool) {
        guard let navigationController else { return }

        let viewModel = PurchaseStatusViewModel(isSuccess: isSuccess) { [weak self] in
            guard let self else { return }

            if isSuccess {
                self.escapeToCatalogue()
            }
        }

        let resultVC = PurchaseStatusView(viewModel)

        resultVC.modalPresentationStyle = .fullScreen
        navigationController.present(resultVC, animated: true)
    }

    func escapeToCatalogue() {
        deps.shoppingCart.nfts.forEach { id in
            deps.shoppingCart.removeFromCart(id)
        }

        navigationController?.popViewController(animated: false)

        tabBarController?.selectedIndex = 1
    }
}
