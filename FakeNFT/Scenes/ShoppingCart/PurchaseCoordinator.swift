import UIKit

final class PurchaseCoordinator {
    weak var navigationController: UINavigationController?
    weak var tabBarController: UITabBarController?

    let deps: Dependencies

    init(deps: Dependencies) {
        self.deps = deps
    }
}

// MARK: - Dependencies

extension PurchaseCoordinator {
    struct Dependencies {
        let currencyProvider: CurrencyProvider
        let shoppingCart: ShoppingCart
        let paymentService: PaymentService
    }
}

// MARK: - Coordinator

extension PurchaseCoordinator: Coordinator {
    func start() {
        displayCurrencySelector()
    }
}

// MARK: - Flow

private extension PurchaseCoordinator {
    func displayCurrencySelector() {
        let viewModel = CurrencySelectViewModel(
            deps: .init(currencyProvider: deps.currencyProvider)
        ) { [weak self] id in
            self?.performPayment(with: id)
        }

        let currencyVC = CurrencySelectView(viewModel)
        currencyVC.hidesBottomBarWhenPushed = true

        navigationController?.pushViewController(currencyVC, animated: true)
    }

    func performPayment(with currencyId: Currency.ID) {
        UIBlockingProgressHUD.show()

        deps.paymentService.pay(with: currencyId) { [weak self] result in
            defer { UIBlockingProgressHUD.dismiss() }

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
                self.finalizePurchase()
            }
        }

        let resultVC = PurchaseStatusView(viewModel)

        resultVC.modalPresentationStyle = .fullScreen
        navigationController.present(resultVC, animated: true)
    }

    func finalizePurchase() {
        deps.shoppingCart.nfts.forEach { id in
            deps.shoppingCart.removeFromCart(id)
        }

        navigationController?.popViewController(animated: false)

        tabBarController?.selectedIndex = 1
    }
}
