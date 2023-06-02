//
//  FakeShoppingCart.swift
//  FakeNFT
//
//  Created by Andrei Chenchik on 31/5/23.
//

final class FakeShoppingCart {
    private var contents: Set<Nft.ID> = []
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
