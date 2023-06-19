import UIKit

struct NftAvatarViewModel {
    let imageURL: URL?
    var isLiked: Bool?
    let likeButtonAction: (() -> Void)?
}
