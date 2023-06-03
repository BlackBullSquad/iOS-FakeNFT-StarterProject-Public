import Foundation

final class NftDeleteViewModel: ObservableObject {
    let avatarURL: URL
    let onDelete: () -> Void

    @Published var isPresented = true

    init(avatarURL: URL, onDelete: @escaping () -> Void) {
        self.avatarURL = avatarURL
        self.onDelete = onDelete
    }
}

// MARK: - Actions

extension NftDeleteViewModel {
    func didDelete() {
        onDelete()
        isPresented = false
    }

    func didCancel() {
        isPresented = false
    }
}
