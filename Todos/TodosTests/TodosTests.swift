//
//  TodosTests.swift
//  TodosTests
//
//  Created by tatsuya ohyama on 2022/07/18.
//

import ComposableArchitecture
import XCTest
@testable import Todos

class TodosTests: XCTestCase {
    
    func testAddTodo() {
        let store = TestStore(
            initialState: AppState(),
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: UUID.incrementing
            )
        )
        
        store.send(.add) {
            $0.todos.insert(
                Todo(
                    id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                    description: "",
                    isComplete: false
                ),
                at: 0
            )
        }
    }
    
    func testCompletingTodo() {
        let state = AppState(
            todos: [
                Todo(
                    id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                    description: "Book",
                    isComplete: false
                )
            ]
        )
        
        let store = TestStore(
            initialState: state,
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: UUID.incrementing
            )
        )
        
        store.send(.todo(id: state.todos[0].id, action: .checkboxTapped)) {
            $0.todos[id: state.todos[0].id]?.isComplete = true
        }
    }
    
    func testDeleteTodo() {
        let state = AppState(
            todos: [
                Todo(
                    id: UUID(uuidString: "00000000-0000-0000-0000-000000000000")!,
                    description: "Book",
                    isComplete: false
                ),
                Todo(
                    id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                    description: "Book",
                    isComplete: false
                ),
                Todo(
                    id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
                    description: "Book",
                    isComplete: false
                )
            ]
        )
        
        let store = TestStore(
            initialState: state,
            reducer: appReducer,
            environment: AppEnvironment(
                uuid: UUID.incrementing
            )
        )
        
        store.send(.delete([1])) {
            $0.todos = [
                $0.todos[0],
                $0.todos[2]
            ]
        }
    }
}

extension UUID {
    static var incrementing: () -> UUID {
        var uuid = 0
        return {
            defer { uuid += 1 }
            return UUID(uuidString: "00000000-0000-0000-0000-\(String(format: "%012x", uuid))")!
        }
    }
}
