import UIKit

struct CollectionViewLayoutFactory {
    
    enum Section: Int {
        case cover, description, collection
    }
    
    static func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let sectionType = Section(rawValue: sectionIndex) else {
                fatalError("Invalid section")
            }
            
            let inset: CGFloat = 16
            
            switch sectionType {
            case .cover:
                // Collection cover image
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalWidth(0.83)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: itemSize,
                    subitem: item,
                    count: 1
                )
                let section = NSCollectionLayoutSection(group: group)
                return section
                
            case .description:
                // Collection text description
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(100)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: itemSize,
                    subitem: item,
                    count: 1
                )
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: inset,
                    leading: inset,
                    bottom: 21,
                    trailing: inset
                )
                return section
                
            case .collection:
                // Collection NFT list
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1/3),
                    heightDimension: .estimated(192)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(192)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitem: item,
                    count: 3
                )
                group.interItemSpacing = .fixed(10)
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(
                    top: 0,
                    leading: inset,
                    bottom: 0,
                    trailing: inset
                )
                section.interGroupSpacing = 20 + 8
                return section
            }
        }
        
        return layout
    }
}
