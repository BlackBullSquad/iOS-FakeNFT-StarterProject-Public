import Foundation

struct OrderDTO {
    let id: String
    let success: Bool
    let orderId: String
}

extension OrderDTO: Decodable {}
