import Foundation

struct UserDTO {
    let id: String

    let name: String
    let description: String
    let rating: String

    let avatar: URL
    let website: URL

    let nfts: [Int]
}

extension UserDTO: Decodable {}
