import Foundation

struct PaymentResultDTO {
    let id: String
    let orderId: String

    let success: Bool
}

extension PaymentResultDTO: Decodable {}
