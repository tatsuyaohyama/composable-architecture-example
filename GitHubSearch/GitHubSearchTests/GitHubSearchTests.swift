import ComposableArchitecture
import XCTest

@testable import GitHubSearch

class GitHubSearchTests: XCTestCase {
    let mainQueue = DispatchQueue.test
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSearchAndClearQuery() {
        let store = TestStore(
            initialState: SearchState(),
            reducer: searchReducer,
            environment: SearchEnvironment(
                gitHubSearchClient: .unimplemented,
                mainQueue: self.mainQueue.eraseToAnyScheduler()
            )
        )
        
        store.environment.gitHubSearchClient.search = { _ in Effect(value: .mock) }
        store.send(.searchQueryChanged("Swift")) {
            $0.searchQuery = "Swift"
        }
        self.mainQueue.advance(by: 0.3)
        store.receive(.searchResponse(.success(.mock))) {
            $0.repositories = Repositories.mock.items
        }
        store.send(.searchQueryChanged("")) {
            $0.repositories = []
            $0.searchQuery = ""
        }
    }
    
    func testSearchFailure() {
        let store = TestStore(
            initialState: SearchState(),
            reducer: searchReducer,
            environment: SearchEnvironment(
                gitHubSearchClient: .unimplemented,
                mainQueue: self.mainQueue.eraseToAnyScheduler()
            )
        )
        
        store.environment.gitHubSearchClient.search = { _ in Effect(error: GitHubSearchClient.Failure()) }
        store.send(.searchQueryChanged("Swift")) {
            $0.searchQuery = "Swift"
        }
        self.mainQueue.advance(by: 0.3)
        store.receive(.searchResponse(.failure(GitHubSearchClient.Failure())))
    }
}
