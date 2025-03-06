import Foundation
import UIKit
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private var url: URL?
    private var cache: ImageCacheProtocol?
    private var cancellable: AnyCancellable?

    init(url: URL?, cache: ImageCacheProtocol? = nil) {
        self.url = url
        self.cache = cache
        loadImage()
    }

    func loadImage() {
        guard let url = url else { return }
        let key = url.absoluteString
        if let cachedImage = cache?.image(forKey: key) {
            self.image = cachedImage
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] img in
                guard let self = self, let img = img else { return }
                self.cache?.insertImage(img, forKey: key)
                self.image = img
            }
    }

    deinit {
        cancellable?.cancel()
    }
}
