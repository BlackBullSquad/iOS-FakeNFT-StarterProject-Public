import UIKit

final class CatalogueCell: UITableViewCell {
    
    static let identifier = "CatalogueCell"
    
    let coverNFT: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "placeholder")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO:
    
    }
