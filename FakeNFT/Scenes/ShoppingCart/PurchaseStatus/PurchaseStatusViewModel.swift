import Foundation

final class PurchaseStatusViewModel: ObservableObject {
    var isSuccess: Bool

    @Published var isPresented = true

    private var onContinue: () -> Void

    init(isSuccess: Bool, onContinue: @escaping () -> Void) {
        self.isSuccess = isSuccess
        self.onContinue = onContinue
    }
}

// MARK: - Actions

extension PurchaseStatusViewModel {
    func didContinue() {
        onContinue()
        isPresented = false
    }
}
