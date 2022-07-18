//
//  AddTodoView.swift
//  Todos
//
//  Created by tatsuya ohyama on 2022/07/18.
//

import ComposableArchitecture
import SwiftUI

struct AddTodoSheetState: Equatable {
    var description: String = ""
    var isInputValid: Bool { self.description.count > 0 }
}

enum AddTodoSheetAction {
    case inputChanged(String)
    case doneButtonTapped
}

let addTodoSheetReducer = Reducer<AddTodoSheetState, AddTodoSheetAction, Void> { state, action, _ in
    switch action {
    case .inputChanged(_):
        return .none
    case .doneButtonTapped:
        return .none
    }
}

struct AddTodoView: View {
    
    let store: Store<AppState, AppAction>
    
    enum FocusField: Hashable {
        case field
    }
    
    @FocusState private var focusedField: FocusField?
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                HStack {
                    Button {
                        viewStore.send(.cancelButtonTapped)
                    } label: {
                        Text("キャンセル")
                    }
                    
                    Spacer()
                    
                    Spacer()
                    
                    Button {
                        viewStore.send(.add)
                    } label: {
                        Text("完了")
                    }
                    .disabled(!viewStore.isInputValid)
                }
                .overlay(
                    Text("新規追加")
                        .fontWeight(.bold)
                    , alignment: .center
                )
                
                Divider()
                
                TextEditor(text: viewStore.binding(
                    get: \.inputText,
                    send: AppAction.inputChanged
                ))
                .frame(maxWidth: .infinity)
                .focused($focusedField, equals: .field)
                .task {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        focusedField = .field
                    }
                }
            }
            .padding()
        }
    }
}
