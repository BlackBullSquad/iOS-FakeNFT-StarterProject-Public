import Foundation

struct OrderDTO {
    let id: String

    let nfts: [Int]
}

extension OrderDTO: Decodable {}
