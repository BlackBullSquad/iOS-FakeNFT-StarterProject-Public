import Foundation

extension CartCell {
    struct ItemViewModel: Hashable {
        var id: Int
        var name: String
        var price: Float
        var rating: Int
        var avatarUrl: URL?
    }
}

extension CartCell.ItemViewModel {
    init(_ model: Nft) {
        self.init(
            id: model.id,
            name: model.name,
            price: model.price,
            rating: model.rating,
            avatarUrl: model.images.first
        )
    }
}
