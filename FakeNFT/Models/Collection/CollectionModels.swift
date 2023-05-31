import Foundation

typealias Collections = [Collection]

struct Collection {
    let id: Int
    let name: String
    let description: String
    let cover: URL?
    let nfts: [Nft]
    
    var nftCount: Int {
        nfts.count
    }
}

struct Nft {
    let id: Int
    let name: String
    let description: String
    let rating: Int
    let images: [URL?]
    let price: Float
}
