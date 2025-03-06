
import SwiftUI

struct StoryDetailView: View {
    let userId: Int
    let imageCache: ImageCacheProtocol
    @StateObject var viewModel: StoryDetailsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showHeart: Bool = false

    init(userId: Int, imageCache: ImageCacheProtocol = ImageCache(), viewModel: StoryDetailsViewModel) {
        self.userId = userId
        self.imageCache = imageCache
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            VStack {
                if let story = viewModel.story {
                    TabView {
                        ForEach(story.images) { image in
                            ZStack {
                                URLImageView(urlString: image.imageUrl, cache: imageCache)
                                    .scaledToFit()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .clipped()
                                    .onTapGesture(count: 2) {
                                        Task {
                                            viewModel.toggleStoryLike(imageId: image.id)
                                        }
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            showHeart = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            withAnimation {
                                                showHeart = false
                                            }
                                        }
                                    }

                                if showHeart {
                                    Image(systemName: "heart.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .foregroundColor(.red)
                                        .transition(.scale)
                                }
                            }
                                .onAppear {
                                    Task {
                                        viewModel.markImageAsSeen(imageId: image.id)
                                    }
                                }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .edgesIgnoringSafeArea(.all)
                }
            }
            .onAppear {
                viewModel.loadStory(for: userId)
            }

            GeometryReader { geometry in
                HStack(spacing: 0) {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.previousImage()
                        }
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.nextImage {
                                dismiss()
                            }
                        }
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            Task { viewModel.loadStory(for: userId) }
            viewModel.startTimer {
                dismiss()
            }
        }
        .onDisappear {
            viewModel.stopTimer()
        }
    }
}


private class FakeStoryDetailsRepository: StoryDetailsRepositoryType {
    func markStoryImageAsSeen(for story: Story, imageId: Int) {

    }
    
    func toggleStoryImageLike(for story: Story, imageId: Int) {

    }
    
    func getStory(for userId: Int) -> Story? {
        Story(id: 1, userId: 1, images: [
            StoryImage(id: 1, imageUrl: "https://www.dummyimage.com/400x600/30b2cf/cfd0e6&text=This+image+is+from+dummyimage.com", postedAt: Date.now),
            StoryImage(id: 2, imageUrl: "https://www.dummyimage.com/400x600/9332cf/cfd0e6&text=This+image+is+from+dummyimage.com", postedAt: Date.now),
            StoryImage(id: 3, imageUrl: "https://www.dummyimage.com/400x600/34cf3e/cfd0e6&text=This+image+is+from+dummyimage.com", postedAt: Date.now),
        ])
    }
}

#Preview {
    StoryDetailView(userId: 1, viewModel: StoryDetailsViewModel(repository: FakeStoryDetailsRepository()))
}
