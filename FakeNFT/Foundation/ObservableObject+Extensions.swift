import Foundation
import Combine

extension ObservableObject {
    func bind(onUpdate: @escaping () -> Void) -> AnyCancellable {
        self
            .objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { _ in
                onUpdate()
            }
    }
}
