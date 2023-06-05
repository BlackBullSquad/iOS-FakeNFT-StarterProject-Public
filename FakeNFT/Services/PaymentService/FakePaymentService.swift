import Foundation

final class FakePaymentService {
    let api: NftAPI

    init(api: NftAPI) {
        self.api = api
    }
}

extension FakePaymentService: PaymentService {
    func pay(with id: Currency.ID, handler: @escaping (Bool) -> Void) {
        api.payOrder(currencyId: id) { result in
            switch result {
            case let .success(data):
                handler(data.success)
            case .failure:
                handler(false)
            }
        }
    }

}
