import Foundation

struct NftCellViewModel {
    let id: Int
    let imageURL: URL?
    let rating: Int
    let name: String
    let price: String
    let isInCart: Bool
    
    init(_ model: Nft, shoppingCartService: ShoppingCart) {
        self.id = model.id
        self.rating = model.rating
        self.imageURL = model.images.first ?? nil
        self.name = model.name
        self.price = "\(String(model.price)) ETH"
        self.isInCart = shoppingCartService.isInShoppingCart(model.id)
    }
}
