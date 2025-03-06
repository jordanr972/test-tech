import SwiftUI

final class StoryDetailsViewModel: ObservableObject {
    @Published var currentImage: Int = 0
    @Published var story: Story?

    private var timerTask: Task<Void, Never>? = nil
    private let timeInterval: TimeInterval = 10.0
    private let repository: StoryDetailsRepositoryType

    init(repository: StoryDetailsRepositoryType) {
        self.repository = repository
    }

    func loadStory(for user: Int) {
        story = repository.getStory(for: user)
    }

    func markImageAsSeen(imageId: Int) {
        guard let story = story else { return }
        repository.markStoryImageAsSeen(for: story, imageId: imageId)
    }

    func toggleStoryLike(imageId: Int) {
        guard let story = story else { return }
        repository.toggleStoryImageLike(for: story, imageId: imageId)
    }

    // MARK: Image timer

    func startTimer(dismiss: @escaping () -> ()) {
        timerTask?.cancel()
        timerTask = Task<Void, Never> {
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: UInt64(timeInterval * 1_000_000_000))
                await MainActor.run {
                    nextImage(dismiss: dismiss)
                }
            }
        }
    }

    func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
    }

    // MARK: Image navigation

    func nextImage(dismiss: @escaping () -> Void) {
        guard let story = story else { return }
        if currentImage < story.images.count - 1 {
            currentImage += 1
        } else {
            dismiss()
        }
    }

    func previousImage() {
        if currentImage > 0 {
            currentImage -= 1
        }
    }
}
