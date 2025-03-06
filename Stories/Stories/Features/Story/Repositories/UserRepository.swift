
import Foundation

struct UsersResponse: Codable {
    let pages: [UsersPage]
}

struct UsersPage: Codable {
    let users: [User]
}

protocol UserRepositoryType {
    func getUsers(page: Int, pageSize: Int) -> [User]
}

final class UserRepository: UserRepositoryType {

    private var users = [User]()

    init() {
        loadUsers()
    }

    private func loadUsers() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        if let url = Bundle.main.url(forResource: "users", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let userResponse = try? decoder.decode(UsersResponse.self, from: data) {
            self.users = userResponse.pages.flatMap { $0.users }
        }
    }

    func getUsers(page: Int, pageSize: Int = 10) -> [User] {
        guard !users.isEmpty else {
            assertionFailure("No users available")
            return []
        }

        var pagedUsers: [User] = []
        let startIndex = (page * pageSize) % users.count

        for i in 0..<pageSize {
            let index = (startIndex + i) % users.count
            pagedUsers.append(users[index])
        }

        return pagedUsers
    }
}
