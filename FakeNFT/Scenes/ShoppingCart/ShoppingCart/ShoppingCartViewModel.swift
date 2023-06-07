import Foundation

final class ShoppingCartViewModel: ObservableObject {
    let deps: Dependencies

    @Published var items: [ShoppingCartCellViewModel] = []
    @Published var sortedBy: SortingOrder = .byName
    @Published var destination: Destination?

    private var onPurchase: () -> Void

    var isCartEmpty: Bool { items.isEmpty }
    var totalPrice: Float { items.map(\.price).reduce(0, +) }
    var priceLabel: String { "\(deps.priceFormatter.string(from: .init(value: totalPrice))!) ETH" }
    var countLabel: String { "\(items.count) NFT" }
    var sortedItems: [ShoppingCartCellViewModel] {
        switch sortedBy {
        case .byPrice:
            return items.sorted { $0.price < $1.price }
        case .byRating:
            return items.sorted { $0.rating > $1.rating }
        case .byName:
            return items.sorted { $0.name < $1.name }
        }
    }

    init(deps: Dependencies, onPurchase: @escaping () -> Void) {
        self.deps = deps
        self.onPurchase = onPurchase
    }
}

extension ShoppingCartViewModel {
    enum Destination {
        case selectingSort
        case deleteItem(NftDeleteViewModel)
        case errorLoading(StatusViewModel)
    }
}

// MARK: - Dependencies

extension ShoppingCartViewModel {
    struct Dependencies {
        let nftProvider: NftProvider
        let shoppingCart: ShoppingCart
        let priceFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
            formatter.decimalSeparator = ","
            formatter.groupingSeparator = ""
            return formatter
        }()
    }
}

// MARK: - Action

extension ShoppingCartViewModel {
    func start() {
        reloadExternalData()
    }

    func refresh() {
        reloadExternalData()
    }

    func requestSorting() {
        destination = .selectingSort
    }

    func selectSorting(by sortedBy: SortingOrder) {
        self.sortedBy = sortedBy
        destination = nil
    }

    func cancelSorting() {
        destination = nil
    }

    func delete(itemId: Nft.ID) {
        guard let item = items.first(where: { $0.id == itemId }) else { return }

        let itemToDelete = NftDeleteViewModel(avatarURL: item.avatarUrl) { [weak self] in
            self?.items.removeAll { $0.id == itemId }
            self?.destination = nil
        } onCancel: { [weak self] in
            self?.destination = nil
        }

        destination = .deleteItem(itemToDelete)
    }

    func purchase() {
        onPurchase()
    }
}

// MARK: - External Data

private extension ShoppingCartViewModel {
    func reloadExternalData() {
        UIBlockingProgressHUD.show()

        let ids = deps.shoppingCart.nfts

        deps.nftProvider.getNfts(Set(ids)) { [weak self] result in
            defer { UIBlockingProgressHUD.dismiss() }
            guard let self else { return }

            switch result {

            case let .success(data):
                self.items = data.compactMap { nft in
                    ShoppingCartCellViewModel(
                        nftModel: nft,
                        deps: .init(priceFormatter: self.deps.priceFormatter)
                    ) {
                        self.delete(itemId: nft.id)
                    }
                }

            case let .failure(error):
                let viewModel = StatusViewModel(
                    continueLabel: "Попробовать еще раз",
                    statusDescription: error.localizedDescription,
                    imageAsset: .statusFailure
                ) { [weak self] in
                    self?.refresh()
                }

                self.destination = .errorLoading(viewModel)
            }
        }
    }
}
