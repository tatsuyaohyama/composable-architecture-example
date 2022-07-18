//
//  TodoRowView.swift
//  Todos
//
//  Created by tatsuya ohyama on 2022/07/18.
//

import ComposableArchitecture
import SwiftUI

struct TodoRowView: View {
    
    let store: Store<Todo, TodoAction>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            HStack {
                Button {
                    viewStore.send(.checkboxTapped)
                } label: {
                    Image(systemName: viewStore.isComplete ? "checkmark.circle" : "circle")
                        .foregroundColor(viewStore.isComplete ? .green : .gray)
                }
                
                Text(viewStore.description)
                    .strikethrough(viewStore.isComplete)
            }
        }
    }
}
