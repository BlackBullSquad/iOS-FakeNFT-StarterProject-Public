import Foundation

final class NftDeleteViewModel: ObservableObject {
    let avatarURL: URL

    @Published var isPresented = true

    private let onDelete: () -> Void
    private let onCancel: () -> Void

    init(avatarURL: URL, onDelete: @escaping () -> Void, onCancel: @escaping () -> Void) {
        self.avatarURL = avatarURL
        self.onDelete = onDelete
        self.onCancel = onCancel
    }
}

// MARK: - Actions

extension NftDeleteViewModel {
    func didDelete() {
        onDelete()
        isPresented = false
    }

    func didCancel() {
        onCancel()
        isPresented = false
    }
}
