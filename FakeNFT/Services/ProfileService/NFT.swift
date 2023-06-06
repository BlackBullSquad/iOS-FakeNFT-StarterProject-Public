//
//  NFT.swift
//  FakeNFT
//
//  Created by MacBook on 03.06.2023.
//

import Foundation

struct NFT {
    let id: String
    let createdAt: Date

    let name: String
    let description: String

    let price: Float
    let rating: Int

    let images: [URL]
    
    init(id: String, createdAt: Date, name: String, description: String, price: Float, rating: Int, images: [URL]) {
        self.id = id
        self.createdAt = createdAt
        self.name = name
        self.description = description
        self.price = price
        self.rating = rating
        self.images = images
    }
    
    init(nftDTO: NftDTO) {
        self.id = nftDTO.id
        self.createdAt = nftDTO.createdAt
        self.name = nftDTO.name
        self.description = nftDTO.description
        self.price = nftDTO.price
        self.rating = nftDTO.rating
        self.images = nftDTO.images
    }
}
