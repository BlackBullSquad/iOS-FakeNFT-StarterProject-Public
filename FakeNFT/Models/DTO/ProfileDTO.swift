import Foundation

struct ProfileDTO {
    let id: String

    let name: String
    let description: String

    let avatar: URL
    let website: URL

    let nfts: [Int]
    let likes: [Int]
}

extension ProfileDTO: Decodable {}
