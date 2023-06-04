import Foundation

final class CurrencySelectViewModel: ObservableObject {
    let deps: Dependencies

    @Published var items: [CurrencySelectCellViewModel] = []
    @Published var selectedItemId: CurrencySelectCellViewModel.ID?

    var isPurchaseAvailable: Bool { selectedItemId != nil }
    var onPurchase: (Int) -> Void

    init(deps: Dependencies, onPurchase: @escaping (Int) -> Void) {
        self.deps = deps
        self.onPurchase = onPurchase
    }
}

// MARK: - Dependencies

extension CurrencySelectViewModel {
    struct Dependencies {
        let currencyProvider: CurrencyProvider
    }
}

// MARK: - Actions

extension CurrencySelectViewModel {
    func start() {
        deps.currencyProvider.getCurrencies { [weak self] result in
            guard let self else { return }

            switch result {
            case let .success(currencies):
                self.items = currencies.map { .init($0, isSelected: $0.id == self.selectedItemId) }
            case let .failure(error):
                print(error)
            }
        }
    }

    func selectedItem(_ index: Int) {
        let selectedId = items[index].id
        selectedItemId = selectedItemId != selectedId ? selectedId : nil
    }

    func purchase() {
        guard let selectedItemId else { return }
        onPurchase(selectedItemId)
    }
}
