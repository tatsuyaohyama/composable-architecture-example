import ComposableArchitecture
import SDWebImageSwiftUI
import SwiftUI

struct SearchState: Equatable {
    var repositories: [Repository] = []
    var searchQuery: String = ""
}

enum SearchAction: Equatable {
    case searchQueryChanged(String)
    case searchResponse(Result<Repositories, GitHubSearchClient.Failure>)
}

struct SearchEnvironment {
    var gitHubSearchClient: GitHubSearchClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let searchReducer = Reducer<SearchState, SearchAction, SearchEnvironment> { state, action, environment in
    switch action {
    case .searchQueryChanged(let searchQuery):
        enum SearchRepositoryId {}
        
        state.searchQuery = searchQuery
        
        guard !searchQuery.isEmpty else {
            state.repositories = []
            return .cancel(id: SearchRepositoryId.self)
        }
        
        return environment.gitHubSearchClient
            .search(searchQuery)
            .debounce(id: SearchRepositoryId.self, for: 0.3, scheduler: environment.mainQueue)
            .catchToEffect(SearchAction.searchResponse)
        
    case .searchResponse(.failure):
        state.repositories = []
        return .none
        
    case .searchResponse(let .success(repositories)):
        state.repositories = repositories.items
        return .none
    }
}

struct SearchView: View {
    
    let store: Store<SearchState, SearchAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        TextField(
                            "repository name",
                            text: viewStore.binding(
                                get: \.searchQuery, send: SearchAction.searchQueryChanged
                            )
                        )
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    }
                    .padding(.horizontal, 16)
                    
                    List {
                        ForEach(viewStore.repositories) { repository in
                            SearchRowView(repository: repository)
                                .overlay(
                                    Link("", destination: URL(string: repository.htmlURL)!)
                                )
                        }
                    }
                    .refreshable {
                        viewStore.send(.searchQueryChanged(viewStore.searchQuery))
                    }
                }
                .navigationTitle("Search")
                .navigationViewStyle(.stack)
            }
        }
    }
}
