import Foundation

struct Repositories: Codable, Equatable {
    let totalCount: Int
    let items: [Repository]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}

struct Repository: Codable, Equatable, Identifiable {
    let id: Int
    let name: String
    let fullName: String
    let owner: Owner
    let htmlURL: String
    let itemDescription: String?
    let stargazersCount: Int
    let watchersCount: Int
    let language: String?
    let forksCount: Int
    let openIssuesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case fullName = "full_name"
        case owner
        case htmlURL = "html_url"
        case itemDescription = "description"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case language
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
    }
}

struct Owner: Codable, Equatable {
    let login: String
    let id: Int
    let avatarURL: String
    let htmlURL: String
    
    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
    }
}
