import Foundation

struct StoriesResponse: Codable {
    let stories: [Story]
}

protocol StoryDetailsRepositoryType {
    func getStory(for userId: Int) -> Story?
    func markStoryImageAsSeen(for story: Story, imageId: Int)
    func toggleStoryImageLike(for story: Story, imageId: Int)
}

final class StoryDetailsRepository: StoryDetailsRepositoryType {
    private var stories = [Story]()

    init() {
        loadStories()
    }

    private func loadStories() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if let url = Bundle.main.url(forResource: "story", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let response = try? decoder.decode(StoriesResponse.self, from: data) {
            stories = response.stories
        }
    }

    func getStory(for userId: Int) -> Story? {
        return stories.first(where: { $0.userId == userId})
    }

    func markStoryImageAsSeen(for story: Story, imageId: Int) {
        if let storyIndex = stories.firstIndex(where: { $0.id == story.id }) {
            if let imageIndex = stories[storyIndex].images.firstIndex(where: { $0.id == imageId }) {
                stories[storyIndex].images[imageIndex].seen = true
            }
        }
    }

    func toggleStoryImageLike(for story: Story, imageId: Int) {
        if let storyIndex = stories.firstIndex(where: { $0.id == story.id }) {
            if let imageIndex = stories[storyIndex].images.firstIndex(where: { $0.id == imageId }) {
                stories[storyIndex].images[imageIndex].liked.toggle()
            }
        }
    }
}
