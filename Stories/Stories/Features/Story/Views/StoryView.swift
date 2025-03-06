
import SwiftUI

struct StoryView: View {
    let users: [User]
    let seenStories: Set<Int>
    let imageCache: ImageCacheProtocol

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(users, id: \.id) { user in
                    NavigationLink(destination: StoryDetailView(userId: user.id, viewModel: StoryDetailsViewModel(repository: StoryDetailsRepository()))) {
                        UserStoryView(user: user,
                                      isSeen: seenStories.contains(user.id),
                                      imageCache: imageCache)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}
