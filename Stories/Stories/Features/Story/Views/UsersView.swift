
import SwiftUI

struct UsersView: View {
    @StateObject var viewModel: UsersViewModel
    private let imageCache = ImageCache()

    init(viewModel: UsersViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    private var content: some View {
        VStack {
            StoryView(users: viewModel.users,
                      seenStories: viewModel.seenStories,
                      imageCache: imageCache)
            .frame(height: 100)
            Spacer()
        }
    }

    var body: some View {
        NavigationView {
            content
                .navigationTitle("Stories")
        }
    }
}

private final class FakeUserRepository: UserRepositoryType {
    func getUsers(page: Int, pageSize: Int) -> [User] {
        [User(id: 1, name: "user1", profilePictureUrl: "https://www.dummyimage.com/400x600/30b2cf/cfd0e6&text=This+image+is+from+dummyimage.com"),
         User(id: 2, name: "user2", profilePictureUrl: "https://www.dummyimage.com/400x600/30b2cf/cfd0e6&text=This+image+is+from+dummyimage.com")]
    }
}

#Preview {
    UsersView(viewModel: UsersViewModel(repository: FakeUserRepository()))
}
