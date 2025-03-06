import SwiftUI

struct URLImageView: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Image

    init(urlString: String, placeholder: Image = Image(systemName: "photo"), cache: ImageCacheProtocol? = nil) {
        _loader = StateObject(wrappedValue: ImageLoader(url: URL(string: urlString), cache: cache))
        self.placeholder = placeholder
    }

    var body: some View {
        if let uiImage = loader.image {
            Image(uiImage: uiImage)
                .resizable()
        } else {
            placeholder
                .resizable()
        }
    }
}
