import UIKit

extension UICollectionViewCompositionalLayout {
    static var currencies: Self {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .absolute(46)))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                              heightDimension: .estimated(10)),
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(7)

        let section = NSCollectionLayoutSection(group: group)

        return .init(section: section)
    }
}
