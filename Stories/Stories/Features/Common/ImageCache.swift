import UIKit

protocol ImageCacheProtocol {
    func image(forKey key: String) -> UIImage?
    func insertImage(_ image: UIImage, forKey key: String)
}

final class ImageCache: ImageCacheProtocol {
    private let cache = NSCache<NSString, UIImage>()

    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }

    func insertImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
