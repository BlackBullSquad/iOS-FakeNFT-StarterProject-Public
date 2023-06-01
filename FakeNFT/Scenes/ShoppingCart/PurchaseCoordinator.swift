import UIKit

protocol Coordinator {
    func start()
}

final class PurchaseCoordinator {
    weak var navigationController: UINavigationController?

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

    }

    func performPayment(with currencyId: Currency.ID) {

    }

    func displayPurchaseResult(isSuccess: Bool) {

    }

    func tryAgain() {

    }

    func getBack() {
        
    }
}
