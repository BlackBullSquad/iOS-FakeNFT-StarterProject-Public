import Foundation

final class CurrencySelectViewModel: ObservableObject {
    let deps: Dependencies

    @Published var items: [CurrencySelectCellViewModel] = []
    @Published var destination: Destination?
    @Published var isLoading: Bool = false

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
        if selectedItemId == items[index].id {
            deselectItem(index)
        } else {
            selectItem(index)
        }
    }

    func purchase() {
        guard let selectedItemId else { return }
        onPurchase(selectedItemId)
    }

    func openTermsAndConditions() {
        destination = .webInfo(.init(string: "https://practicum.com/")!)
    }

    func active() {
        destination = nil
    }
}

// MARK: - Helpers

private extension CurrencySelectViewModel {
    var selectedItemIndex: Int? { items.firstIndex(where: { $0.id == selectedItemId }) }

    func selectItem(_ index: Int) {
        if let selectedItemIndex {
            items[selectedItemIndex].isSelected = false
        }

        items[index].isSelected = true
        selectedItemId = items[index].id
    }

    func deselectItem(_ index: Int) {
        items[index].isSelected = false
        selectedItemId = nil
    }
}

// MARK: - External Data

private extension CurrencySelectViewModel {
    func reloadExternalData() {
        isLoading = true

        deps.currencyProvider.getCurrencies { [weak self] result in
            guard let self else { return }
            defer { self.isLoading = false }

            switch result {
            case let .success(currencies):
                self.items = currencies.map { .init($0, isSelected: $0.id == self.selectedItemId) }
            case let .failure(error):
                self.destination = .errorLoading(
                    .init(
                        continueLabel: "Попробовать еще раз",
                        statusDescription: error.localizedDescription,
                        imageAsset: .statusFailure
                    ) { [weak self] in
                        self?.retryLoadingData()
                    }
                )
            }
        }
    }
}
