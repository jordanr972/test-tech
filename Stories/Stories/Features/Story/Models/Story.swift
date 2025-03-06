//
//  Story.swift
//  Stories
//
//  Created by Jordan Ruster on 06/03/2025.
//

import Foundation

struct Story: Identifiable, Codable {
    let id: Int
    let userId: Int
    var images: [StoryImage]

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case images
    }
}
