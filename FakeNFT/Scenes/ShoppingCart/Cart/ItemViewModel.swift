import Foundation

extension ShoppingCartCell {
    struct ItemViewModel: Hashable {
        var id: Int
        var name: String
        var price: Float
        var rating: Int
        var avatarUrl: URL
    }
}

extension ShoppingCartCell.ItemViewModel {
    init?(_ model: Nft) {
        guard let avatarUrl = model.images.first else { return nil }

        self.init(
            id: model.id,
            name: model.name,
            price: model.price,
            rating: model.rating,
            avatarUrl: avatarUrl
        )
    }
}
