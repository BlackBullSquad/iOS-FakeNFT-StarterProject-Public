import Foundation

final class StatusViewModel: ObservableObject {
    let continueLabel: String
    let statusDescription: String
    let imageAsset: String

    @Published var isPresented = true

    private var onContinue: () -> Void

    init(
        continueLabel: String,
        statusDescription: String,
        imageAsset: String,
        onContinue: @escaping () -> Void
    ) {
        self.continueLabel = continueLabel
        self.statusDescription = statusDescription
        self.imageAsset = imageAsset
        self.onContinue = onContinue
    }
}

// MARK: - Actions

extension StatusViewModel {
    func didContinue() {
        onContinue()
        isPresented = false
    }
}
