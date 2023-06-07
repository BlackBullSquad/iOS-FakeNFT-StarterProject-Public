import Foundation

final class StatusViewModel: ObservableObject {
    let continueLabel: String
    let statusDescription: String
    let imageAsset: ImageAsset

    @Published var isPresented = true

    private var onContinue: () -> Void

    init(
        continueLabel: String,
        statusDescription: String,
        imageAsset: ImageAsset,
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
