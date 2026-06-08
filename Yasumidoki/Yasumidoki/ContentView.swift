//
//  ContentView.swift
//  Yasumidoki
//
//  Created by hiroshi imaizumi on 2026/06/08.
//

import SwiftUI
import YasumidokiCore

struct ContentView: View {
    @State private var model = AppModel(store: InMemoryYasumidokiStore())

    var body: some View {
        AppRootView()
            .environment(model)
    }
}

#Preview {
    ContentView()
}
