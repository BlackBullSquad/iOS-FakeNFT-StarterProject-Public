//
//  ShoppingCart.swift
//  FakeNFT
//
//  Created by Andrei Chenchik on 31/5/23.
//

protocol ShoppingCart {
    func addToCart(_ id: Nft.ID)
    func removeFromCart(_ id: Nft.ID)
    func isInShoppingCart(_ id: Nft.ID) -> Bool
    var nfts: [Nft.ID] { get }
}
