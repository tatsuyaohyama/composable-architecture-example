//
//  ContentView.swift
//  Todos
//
//  Created by tatsuya ohyama on 2022/07/18.
//

import ComposableArchitecture
import SwiftUI

struct AppState: Equatable {
    var todos: IdentifiedArrayOf<Todo> = []
    var editMode: EditMode = .inactive
    var inputText: String = ""
    var isInputValid: Bool { self.inputText.count > 0 }
    var showAddTodoView: Bool = false
}

enum AppAction: Equatable {
    case setSheet(isPresented: Bool)
    case add
    case inputChanged(String)
    case cancelButtonTapped
    case editModeChanged(EditMode)
    case delete(IndexSet)
    case todo(id: UUID, action: TodoAction)
}

struct AppEnvironment {
    var uuid: () -> UUID
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    todoReducer.forEach(
        state: \.todos,
        action: /AppAction.todo(id:action:),
        environment: { _ in TodoEnvironment() }
    ),
    Reducer { state, action, environment in
        switch action {
        case .setSheet(isPresented: true):
            state.showAddTodoView = true
            return .none
            
        case .setSheet(isPresented: false):
            state.showAddTodoView = false
            state.inputText = ""
            return .none
            
        case .add:
            state.showAddTodoView = false
            let todo = Todo(id: environment.uuid(), description: state.inputText, isComplete: false)
            state.todos.insert(todo, at: 0)
            return .none
            
        case let .inputChanged(newValue):
            state.inputText = newValue
            return .none
            
        case .cancelButtonTapped:
            state.showAddTodoView = false
            return .none
            
        case let .editModeChanged(editMode):
            state.editMode = editMode
            return .none
            
        case let .delete(indexSet):
            state.todos.remove(atOffsets: indexSet)
            return .none
            
        case .todo(id: let id, action: let action):
            return .none
        }
    }
)
    .debug()

struct ContentView: View {
    
    let store: Store<AppState, AppAction>
    
    var body: some View {
        NavigationView {
            WithViewStore(store) { viewStore in
                List {
                    ForEachStore(
                        store.scope(state: \.todos, action: AppAction.todo(id:action:))
                    ) {
                        TodoRowView(store: $0)
                            .buttonStyle(.plain)
                    }
                    .onDelete { viewStore.send(.delete($0)) }
                }
                .navigationTitle("Todos")
                .navigationViewStyle(.stack)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewStore.send(.setSheet(isPresented: true))
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                    }
                }
                .environment(
                    \.editMode,
                     viewStore.binding(get: \.editMode, send: AppAction.editModeChanged)
                )
                .sheet(isPresented: viewStore.binding(
                    get: \.showAddTodoView,
                    send: AppAction.setSheet(isPresented:))) {
                        AddTodoView(store: store)
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: Store(
                initialState: AppState(
                    todos: [
                        Todo(id: UUID(), description: "", isComplete: false)
                    ],
                    showAddTodoView: false
                ),
                reducer: appReducer,
                environment: AppEnvironment(uuid: UUID.init)
            )
        )
    }
}
