import SwiftUI

struct UserStoryView: View {
    let user: User
    let isSeen: Bool
    let imageCache: ImageCacheProtocol

    var body: some View {
        VStack(spacing: 4) {
            URLImageView(urlString: user.profilePictureUrl, cache: imageCache)
                .frame(width: 70, height: 70)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(isSeen ? Color.gray : Color.green, lineWidth: 3)
                )
            Text(user.name)
                .font(.caption)
                .lineLimit(1)
        }
    }
}
