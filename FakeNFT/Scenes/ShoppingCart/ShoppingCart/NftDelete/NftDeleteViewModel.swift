import Foundation

final class NftDeleteViewModel: ObservableObject {
    let avatarURL: URL

    let onDelete: () -> Void
    let onCancel: () -> Void

    @Published var isPresented = true

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
