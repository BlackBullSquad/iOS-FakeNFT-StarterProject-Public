import UIKit

enum NFTAvatarSize: CGFloat {
    case small = 80
    case large = 108
}

struct NFTAvatarViewModel {
    let imageSize: NFTAvatarSize
    let imageURL: URL?
    var isLiked: Bool
    let likeButtonAction: (() -> Void)
}
