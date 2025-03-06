import Foundation

struct StoryImage: Identifiable, Codable {
    let id: Int
    let imageUrl: String
    let postedAt: Date
    var seen: Bool = false
    var liked: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, seen, liked
        case imageUrl = "url"
        case postedAt = "posted_at"
    }
}
