//
//  Todo.swift
//  Todos
//
//  Created by tatsuya ohyama on 2022/07/18.
//

import ComposableArchitecture
import SwiftUI

struct Todo: Equatable, Identifiable {
    var id: UUID
    var description: String
    var isComplete: Bool
}

enum TodoAction: Equatable {
    case checkboxTapped
}

struct TodoEnvironment {}

let todoReducer = Reducer<Todo, TodoAction, TodoEnvironment> { state, action, environment in
    switch action {
    case .checkboxTapped:
        state.isComplete.toggle()
        return .none
    }
}
