final class FakeShoppingCart {
    private var contents: Set<Nft.ID> = [0, 1, 2, 3]
}

extension FakeShoppingCart: ShoppingCart {
    func addToCart(_ id: Nft.ID) {
        contents.insert(id)
    }

    func removeFromCart(_ id: Nft.ID) {
        contents.remove(id)
    }

    func isInShoppingCart(_ id: Nft.ID) -> Bool {
        contents.contains(id)
    }

    var nfts: [Nft.ID] { Array(contents).sorted() }
}
