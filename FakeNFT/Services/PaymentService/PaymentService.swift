protocol PaymentService {
    func pay(with id: Currency.ID, handler: @escaping (Bool) -> Void)
}
