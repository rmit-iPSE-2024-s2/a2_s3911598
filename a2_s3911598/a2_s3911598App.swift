//
//  a2_s3911598App.swift
//  a2_s3911598
//
//  Created by lea wang on 30/9/2024.
//

import SwiftUI

@main
struct a2_s3911598App: App {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light) // base on  isDarkMode to set environment
        }
        .modelContainer(for: [Mood.self, Task.self])
    }
}

