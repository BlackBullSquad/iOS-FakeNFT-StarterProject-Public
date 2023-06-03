import Foundation

final class PurchaseStatusViewModel: ObservableObject {
    var isSuccess: Bool
    var onContinue: () -> Void

    @Published var isPresented = true

    init(isSuccess: Bool, onContinue: @escaping () -> Void) {
        self.isSuccess = isSuccess
        self.onContinue = onContinue
    }
}

extension PurchaseStatusViewModel {
    func didContinue() {
        onContinue()
        isPresented = false
    }
}
