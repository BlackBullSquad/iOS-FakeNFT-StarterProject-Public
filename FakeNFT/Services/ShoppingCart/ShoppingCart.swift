protocol ShoppingCart {
    func addToCart(_ id: Nft.ID)
    func removeFromCart(_ id: Nft.ID)
    func isInShoppingCart(_ id: Nft.ID) -> Bool
    func purchaseCompleted()
    var nfts: [Nft.ID] { get }
}
