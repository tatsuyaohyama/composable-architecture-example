//
//  TodosApp.swift
//  Todos
//
//  Created by tatsuya ohyama on 2022/07/18.
//

import ComposableArchitecture
import SwiftUI

@main
struct TodosApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(store: Store(initialState: AppState(), reducer: appReducer, environment: AppEnvironment(uuid: UUID.init)))
        }
    }
}
