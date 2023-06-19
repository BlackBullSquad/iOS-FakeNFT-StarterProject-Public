import Foundation

struct UpdateOrderDTO {
    let nfts: [Int]
}

extension UpdateOrderDTO: Encodable {}
