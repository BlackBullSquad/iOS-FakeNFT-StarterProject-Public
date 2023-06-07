import Foundation

struct UpdateProfileDTO {
    let name: String
    let description: String

    let website: URL

    let likes: [Int]
}

extension UpdateProfileDTO: Encodable {}
