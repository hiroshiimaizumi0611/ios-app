//
//  YasumidokiApp.swift
//  Yasumidoki
//
//  Created by hiroshi imaizumi on 2026/06/08.
//

import SwiftUI

@main
struct YasumidokiApp: App {
    @State private var model = AppModel(
        store: YasumidokiStoreFactory.makeStore()
    )

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environment(model)
                .task {
                    await model.load()
                }
        }
    }
}
