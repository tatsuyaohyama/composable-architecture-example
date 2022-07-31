import ComposableArchitecture
import SwiftUI

@main
struct GitHubSearchApp: App {
    var body: some Scene {
        WindowGroup {
            SearchView(
                store: Store(
                    initialState: SearchState(),
                    reducer: searchReducer.debug(),
                    environment: SearchEnvironment(
                        gitHubSearchClient: GitHubSearchClient.live,
                        mainQueue: .main
                    )
                )
            )
        }
    }
}
