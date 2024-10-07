//
//  a2_s3911598App.swift
//  a2_s3911598
//
//  Created by lea wang on 30/9/2024.
//

import SwiftUI


@main
struct a2_s3911598App: App {

    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .modelContainer(for: [Mood.self])
        }
    }
}
