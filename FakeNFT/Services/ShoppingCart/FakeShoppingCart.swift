import Foundation

final class FakeShoppingCart {
    static let defaultsKey = "shoppingCart"

    let defaults: UserDefaults

    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
}

extension FakeShoppingCart {
    private var contents: Set<Nft.ID> {
        get {
            let array = defaults.object(forKey: Self.defaultsKey) as? [Nft.ID] ?? [0, 1, 2, 3, 4, 5]
            return Set(array)
        }

        set {
            defaults.set(Array(newValue), forKey: Self.defaultsKey)
        }
    }
}

extension FakeShoppingCart: ShoppingCart {
    func addToCart(_ id: Nft.ID) {
        contents.insert(id)
    }

    func removeFromCart(_ id: Nft.ID) {
        contents.remove(id)
    }

    func isInShoppingCart(_ id: Nft.ID) -> Bool {
        contents.contains(id)
    }

    var nfts: [Nft.ID] { Array(contents).sorted() }
}
