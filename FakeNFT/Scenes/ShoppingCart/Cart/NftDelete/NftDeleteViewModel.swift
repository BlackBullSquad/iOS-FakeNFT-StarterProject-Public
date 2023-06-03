import Foundation

final class NftDeleteViewModel: ObservableObject {
    @Published var avatarURL: URL
    @Published var isPresented = true
    let onDelete: () -> Void

    init(avatarURL: URL, onDelete: @escaping () -> Void) {
        self.avatarURL = avatarURL
        self.onDelete = onDelete
    }
}

// MARK: User Actions

extension NftDeleteViewModel {
    func didTapDeleteButton() {
        onDelete()
        isPresented = false
    }

    func didTapCancelButton() {
        isPresented = false
    }
}
