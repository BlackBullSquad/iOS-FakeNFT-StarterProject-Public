import Foundation

struct NftDTO {
    let id: String
    let createdAt: Date

    let name: String
    let description: String

    let price: Float
    let rating: Int

    let images: [URL]
}

extension NftDTO: Decodable {}
