
import SwiftUI

@MainActor
final class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var seenStories: Set<Int> = []

    private var currentPage: Int = 0
    private var isLoading: Bool = false
    private let repository: UserRepositoryType


    init(repository: UserRepositoryType) {
        self.repository = repository
        Task { loadUsers() }
    }

    func loadUsers() {
        guard !isLoading else { return }

        isLoading = true
        let fetchedUsers = repository.getUsers(page: currentPage, pageSize: 10)
        users.append(contentsOf: fetchedUsers)
        currentPage+=1
        isLoading = false
    }
}
