//
//  Nft.swift
//  FakeNFT
//
//  Created by Andrei Chenchik on 31/5/23.
//

import Foundation

struct Nft: Identifiable {
    let id: Int
    let name: String
    let description: String
    let rating: Int
    let images: [URL]
    let price: Float
}
