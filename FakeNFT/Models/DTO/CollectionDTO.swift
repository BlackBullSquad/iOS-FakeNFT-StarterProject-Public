import Foundation

struct CollectionDTO {
    let id: String
    let createdAt: Date

    let name: String
    let description: String

    let nfts: [Int]

    let cover: String
}

extension CollectionDTO: Decodable {}
