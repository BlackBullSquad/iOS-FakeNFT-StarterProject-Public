import Foundation

final class CurrencySelectViewModel: ObservableObject {
    let deps: Dependencies

    @Published var items: [CurrencySelectCellViewModel] = []
    @Published var destination: Destination?

    var isPurchaseAvailable: Bool { selectedItemId != nil }

    private var selectedItemId: CurrencySelectCellViewModel.ID?
    private var onPurchase: (Int) -> Void

    init(deps: Dependencies, onPurchase: @escaping (Int) -> Void) {
        self.deps = deps
        self.onPurchase = onPurchase
    }
}

extension CurrencySelectViewModel {
    enum Destination {
        case webInfo(URL)
        case errorLoading(StatusViewModel)
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
        reloadExternalData()
    }

    func retryLoadingData() {
        reloadExternalData()
    }

    func selectedItem(_ index: Int) {
        let newSelectedId = items[index].id

        if selectedItemId == newSelectedId {
            items[index].isSelected = false
            selectedItemId = nil
            return
        }

        if let currentIndex = items.firstIndex(where: { $0.id == selectedItemId }) {
            items[currentIndex].isSelected = false
        }

        items[index].isSelected = true
        selectedItemId = newSelectedId
    }

    func purchase() {
        guard let selectedItemId else { return }
        onPurchase(selectedItemId)
    }

    func openTermsAndConditions() {
        destination = .webInfo(.init(string: "https://practicum.com/")!)
    }
}

// MARK: - External Data

private extension CurrencySelectViewModel {
    func reloadExternalData() {
        UIBlockingProgressHUD.show()

        deps.currencyProvider.getCurrencies { [weak self] result in
            defer { UIBlockingProgressHUD.dismiss() }

            guard let self else { return }

            switch result {
            case let .success(currencies):
                self.items = currencies.map { .init($0, isSelected: $0.id == self.selectedItemId) }
            case let .failure(error):
                self.destination = .errorLoading(
                    .init(
                        continueLabel: "Попробовать еще раз",
                        statusDescription: error.localizedDescription,
                        imageAsset: "statusFailure"
                    ) { [weak self] in
                        self?.retryLoadingData()
                    }
                )
            }
        }
    }
}
