import UIKit

final class CatalogueVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .magenta
        title = "Каталог"

        let avatarView = NFTAvatarView()
        avatarView.translatesAutoresizingMaskIntoConstraints = false

        let imageURL = URL(string: "https://podarki.ru/gate/8d850520-0bde-4922-a1f1-b203cf177234/links-set/3af29402-0255-4f56-83fc-6d32cadf7b48/picture/96de30c0-da5a-4caf-8a25-3fed979df1ed.jpg")
        let viewModel = NFTAvatarViewModel(
            imageSize: .large,
            imageURL: imageURL,
            isLiked: false,
            likeButtonAction: {
                print("Like button was tapped!")
            }
        )
        avatarView.viewModel = viewModel

        view.addSubview(avatarView)

        NSLayoutConstraint.activate([
            avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: NFTAvatarSize.large.rawValue),
            avatarView.heightAnchor.constraint(equalToConstant: NFTAvatarSize.large.rawValue)
        ])
    }

}
