//
//  Profile.swift
//  FakeNFT
//
//  Created by MacBook on 03.06.2023.
//

import Foundation

struct Profile {
    let id: String

    let name: String
    let description: String

    let avatar: URL
    let website: URL

    let nfts: [Int]
    let likes: [Int]
    
    init(id: String, name: String, description: String, avatar: URL, website: URL, nfts: [Int], likes: [Int]) {
        self.id = id
        self.name = name
        self.description = description
        self.avatar = avatar
        self.website = website
        self.nfts = nfts
        self.likes = likes
    }
    
    init(profileDTO: ProfileDTO) {
        id = profileDTO.id
        name = profileDTO.name
        description = profileDTO.description
        avatar = profileDTO.avatar
        website = profileDTO.website
        nfts = profileDTO.nfts
        likes = profileDTO.likes
    }
}
