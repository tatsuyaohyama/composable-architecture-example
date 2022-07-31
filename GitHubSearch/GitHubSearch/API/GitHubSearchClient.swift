import ComposableArchitecture
import SwiftUI

struct GitHubSearchClient {
    var search: (String) -> Effect<Repositories, Failure>
    
    struct Failure: Error, Equatable {}
}

extension GitHubSearchClient {
    static let live = GitHubSearchClient(
        search: { query in
            var components = URLComponents(string: "https://api.github.com/search/repositories")!
            components.queryItems = [URLQueryItem(name: "q", value: query)]
            
            return URLSession.shared.dataTaskPublisher(for: components.url!)
                .map { data, _ in data }
                .decode(type: Repositories.self, decoder: JSONDecoder())
                .mapError { _ in Failure() }
                .eraseToEffect()
        }
    )
}

// MARK: - Mock API

extension GitHubSearchClient {
    static let unimplemented = Self(
        search: { _ in .unimplemented("\(Self.self).search") }
    )
}

extension Repositories {
    static let mock = Self(
        totalCount: 3,
        items: [
            Repository(
                id: 44838949,
                name: "swift",
                fullName: "apple/swift",
                owner: Owner(
                    login: "apple",
                    id: 10639145,
                    avatarURL: "https://avatars.githubusercontent.com/u/10639145?v=4",
                    htmlURL: "https://github.com/apple"
                ),
                htmlURL: "https://github.com/apple/swift",
                itemDescription: "The Swift Programming Language",
                stargazersCount: 60207,
                watchersCount: 60207,
                language: "C++",
                forksCount: 9689,
                openIssuesCount: 5997
            ),
            Repository(
                id: 20965586,
                name: "SwiftyJSON",
                fullName: "SwiftyJSON/SwiftyJSON",
                owner: Owner(
                    login: "SwiftyJSON",
                    id: 8858017,
                    avatarURL: "https://avatars.githubusercontent.com/u/8858017?v=4",
                    htmlURL: "https://github.com/SwiftyJSON"
                ),
                htmlURL: "https://github.com/SwiftyJSON/SwiftyJSON",
                itemDescription: "The better way to deal with JSON data in Swift.",
                stargazersCount: 21463,
                watchersCount: 21463,
                language: "Swift",
                forksCount: 3338,
                openIssuesCount: 135
            ),
            Repository(
                id: 20822291,
                name: "SwiftGuide",
                fullName: "ipader/SwiftGuide",
                owner: Owner(
                    login: "ipader",
                    id: 373016,
                    avatarURL: "https://avatars.githubusercontent.com/u/373016?v=4",
                    htmlURL: "https://github.com/ipader"
                ),
                htmlURL: "https://github.com/ipader/SwiftGuide",
                itemDescription: "Swift Featured Projects in brain Mapping",
                stargazersCount: 15726,
                watchersCount: 15726,
                language: "Swift",
                forksCount: 3636,
                openIssuesCount: 0
            ),
        ]
    )
}

