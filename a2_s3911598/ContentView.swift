//
//  ContentView.swift
//  a1_s3911598
//
//  Created by Lea Wang on 27/8/2024.
//

import SwiftUI

enum MoodViewDestination: Hashable {
    case moodTracking
}

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                DailyTaskView().modelContainer(for: [Task.self])
            }
            .tabItem {
                Label("Tasks", systemImage: "list.bullet")
            }
            NavigationView {
                MoodView()
            }
            .tabItem {
                Label("Moods", systemImage: "face.smiling")
            }
            
            NavigationView {
                FriendView()
            }
            .tabItem {
                Label("Friends", systemImage: "person.3.fill")
            }
            
            NavigationView {
                SettingView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}



struct FriendView: View {
    var body: some View {
        Text("Friends Content")
            .navigationTitle("Friends")
    }
}

struct SettingView: View {
    var body: some View {
        Text("Settings Content")
            .navigationTitle("Settings")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
