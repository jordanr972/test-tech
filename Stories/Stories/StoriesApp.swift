//
//  StoriesApp.swift
//  Stories
//
//  Created by Jordan Ruster on 06/03/2025.
//

import SwiftUI

@main
struct StoriesApp: App {
    var body: some Scene {
        WindowGroup {
            let repository = UserRepository()
            let viewModel = UsersViewModel(repository: repository)
            UsersView(viewModel: viewModel)
        }
    }
}
