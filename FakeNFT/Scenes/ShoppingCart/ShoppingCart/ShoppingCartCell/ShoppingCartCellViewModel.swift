import Foundation

struct ShoppingCartCellViewModel {
    private let deps: Dependencies

    var id: Int
    var name: String
    var price: Float
    var rating: Int
    var avatarUrl: URL

    var onDelete: () -> Void

    var priceLabel: String { "\(deps.priceFormatter.string(from: .init(value: price))!) ETH" }

    init?(nftModel model: Nft, deps: Dependencies, onDelete: @escaping () -> Void) {
        guard let avatarUrl = model.images.first else { return nil }

        self.deps = deps
        self.id = model.id
        self.name = model.name
        self.price = model.price
        self.rating = model.rating
        self.avatarUrl = avatarUrl
        self.onDelete = onDelete
    }
}

// MARK: - Dependencies

extension ShoppingCartCellViewModel {
    struct Dependencies {
        let priceFormatter: NumberFormatter
    }
}

// MARK: - Hashable & Equatable

extension ShoppingCartCellViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(price)
        hasher.combine(rating)
        hasher.combine(avatarUrl)
    }
}

extension ShoppingCartCellViewModel: Equatable {
    static func == (lhs: ShoppingCartCellViewModel, rhs: ShoppingCartCellViewModel) -> Bool {
        lhs.id == rhs.id
        && lhs.name == rhs.name
        && lhs.price == rhs.price
        && lhs.rating == rhs.rating
        && lhs.avatarUrl == rhs.avatarUrl
    }
}
