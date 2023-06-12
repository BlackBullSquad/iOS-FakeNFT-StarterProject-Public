import Foundation

class NftCellViewModel {
    let id: Int
    let imageURL: URL?
    let rating: Int
    let name: String
    let price: String
    var isInCart: Bool
    
    private let shoppingCartService: ShoppingCart
    
    init(_ model: Nft, shoppingCartService: ShoppingCart) {
        self.id = model.id
        self.rating = model.rating
        self.imageURL = model.images.first ?? nil
        self.name = model.name
        self.price = "\(String(model.price)) ETH"
        self.isInCart = shoppingCartService.isInShoppingCart(model.id)
        LogService.shared.log("isInCart id: \(model.id) — \(isInCart)")
        self.shoppingCartService = shoppingCartService
    }

    func toggleCartStatus() {
        isInCart = !isInCart
        
        if isInCart {
            shoppingCartService.addToCart(self.id)
            LogService.shared.log("ID: \(self.id) added to cart", level: .info)
        } else {
            shoppingCartService.removeFromCart(self.id)
        }
    }
}
