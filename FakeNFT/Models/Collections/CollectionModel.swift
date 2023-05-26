import Foundation

struct CollectionModel {
    let id: Int
    let createdAt: Date
    let name: String
    let description: String
    let nfts: [Int]
    let cover: URL
}
