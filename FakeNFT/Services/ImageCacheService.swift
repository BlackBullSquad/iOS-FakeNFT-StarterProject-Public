import Foundation
import Kingfisher

class ImageCacheService {

    static let shared = ImageCacheService()

    init() {
        setupImageCache()
    }

    private func setupImageCache() {
        let diskCacheSize: UInt = 512 * 1024 * 1024
        let memoryCacheSize: UInt = 128 * 1024 * 1024

        ImageCache.default.memoryStorage.config.totalCostLimit = Int(memoryCacheSize)
        ImageCache.default.diskStorage.config.sizeLimit = diskCacheSize
    }

    func checkCacheStatus(for result: Result<RetrieveImageResult, KingfisherError>) {
        switch result {
        case .success:
            calculateDiskCacheSize()
        case .failure(let error):
            LogService.shared.log("Failed to download image: \(error.localizedDescription)", level: .error)
        }
    }

    private func calculateDiskCacheSize() {
        ImageCache.default.calculateDiskStorageSize { result in
            switch result {
            case .success(let size):
                let sizeInMB = Double(size) / 1024 / 1024
                LogService.shared.log("Disk cache size: \(sizeInMB) MB")
            case .failure(let error):
                LogService.shared.log("Error calculating disk cache size: \(error)", level: .error)
            }
        }
    }
}
