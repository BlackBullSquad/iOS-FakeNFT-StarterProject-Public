import UIKit

enum NftAvatarSize: CGFloat {
    case small = 80
    case large = 108
}

struct NftAvatarViewModel {
    let imageSize: NftAvatarSize
    let imageURL: URL?
    var isLiked: Bool
    let likeButtonAction: (() -> Void)
}
