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
    }
}

extension PurchaseCoordinator: Coordinator {
    func start() {
        deps.currencyProvider.getCurrencies { result in
            switch result {
            case let .success(currencies):
                DispatchQueue.main.async { [weak self] in
                    self?.displayCurrencySelector(currencies: currencies)
                }
            case let .failure(error):
                print(error)
            }
        }
    }

    func displayCurrencySelector(currencies: [Currency]) {
        displayPurchaseResult(isSuccess: true)
    }

    func performPayment(with currencyId: Currency.ID) {

    }

    func displayPurchaseResult(isSuccess: Bool) {
        guard let navigationController else { return }

        let resultVC = PurchaseStatusController(isSuccess: isSuccess)

        if isSuccess {
            resultVC.onContinue = { [weak self] in
                guard let self else { return }
                self.escapeToCatalogue()
            }
        }

        resultVC.modalPresentationStyle = .fullScreen
        navigationController.present(resultVC, animated: true)
    }

    func escapeToCatalogue() {
        tabBarController?.selectedIndex = 1
    }
}
