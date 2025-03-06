//
//  User.swift
//  Stories
//
//  Created by Jordan Ruster on 06/03/2025.
//

struct User: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let profilePictureUrl: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case profilePictureUrl = "profile_picture_url"
    }
}
