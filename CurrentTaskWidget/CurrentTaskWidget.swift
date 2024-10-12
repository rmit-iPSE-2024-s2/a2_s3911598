//
//  CurrentTaskWidget.swift
//  CurrentTaskWidget
//
//  Created by lea.Wang  on 7/10/2024.
//

import WidgetKit
import SwiftUI

/// `Provider` serves as the data provider for the widget, responsible for fetching the latest task and generating timelines.
struct Provider: TimelineProvider {
    
    /// Provides a placeholder task entry for the widget gallery, used when the widget is not fully loaded.
    /// - Parameter context: The widget context.
    /// - Returns: A `TaskEntry` with a placeholder task.
    func placeholder(in context: Context) -> TaskEntry {
        // Provide a placeholder task for the widget gallery
        TaskEntry(date: Date(), task: TaskCodable.placeholder)
    }
    
    /// Provides a snapshot of the current widget state.
    /// - Parameters:
    ///   - context: The widget context.
    ///   - completion: A closure to call when the snapshot is ready, returning the latest task.
    func getSnapshot(in context: Context, completion: @escaping (TaskEntry) -> Void) {
        // Provide a snapshot for the widget
        let entry = TaskEntry(date: Date(), task: getLatestTask())
        completion(entry)
    }
    
    
    /// Generates a timeline of the widget with periodic updates.
    /// - Parameters:
    ///   - context: The widget context.
    ///   - completion: A closure to call when the timeline is ready.
    ///   - policy: The update policy for the widget, set to refresh every 15 minutes.
    func getTimeline(in context: Context, completion: @escaping (Timeline<TaskEntry>) -> Void) {
        // Generate a timeline consisting of a single entry
        let currentDate = Date()
        let entry = TaskEntry(date: currentDate, task: getLatestTask())

        // Refresh after 15 minutes or when you expect the data to change
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!

        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        completion(timeline)
    }
}


/// `TaskEntry` is a model that represents a timeline entry for the widget, containing a task and a timestamp.
struct TaskEntry: TimelineEntry {
    let date: Date
    let task: TaskCodable?
}


/// Retrieves the latest task from `UserDefaults`.
/// - Returns: A `TaskCodable?`, representing the latest task if available, or `nil` if no tasks are found.
func getLatestTask() -> TaskCodable? {
    if let sharedDefaults = UserDefaults(suiteName: "group.com.a2-s3911598.a2-s3911598"),
       let taskData = sharedDefaults.data(forKey: "allTasks"),
       let tasks = try? JSONDecoder().decode([TaskCodable].self, from: taskData) {
        
        // Get the latest task based on the time (you can adjust this based on your logic)
        return tasks.sorted { $0.time > $1.time }.first
    }
    return nil
}



/// `CurrentTaskWidgetEntryView` is the main view of the widget that displays the current task.
/// If no task is available, it displays a "No current task" message.
struct CurrentTaskWidgetEntryView: View {
    var entry: TaskEntry

    var body: some View {
            if let task = entry.task {
                VStack(alignment: .leading, spacing: 5) {
                    Text(task.title)
                        .font(.custom("Chalkboard SE", size: 20))
                        .bold()
                    Text(task.taskDescription)
                        .font(.custom("Chalkboard SE", size: 16))
                        .lineLimit(2)
                }
                .padding()
            } else {
                Text("No current task")
                    .font(.custom("Chalkboard SE", size: 20))
                    .padding()
            }
    }
}

/// `CurrentTaskWidget` defines the widget configuration and appearance.
/// It provides a widget that displays the current task to the user.
struct CurrentTaskWidget: Widget {
    let kind: String = "CurrentTaskWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CurrentTaskWidgetEntryView(entry: entry)
                .containerBackground(Color("secondaryLilac"), for: .widget)
//                .frame(maxWidth: .infinity, maxHeight: .infinity)    // << here !!
//                .background(Color("secondaryLilac"))
        }
        .configurationDisplayName("Current Task")
        .description("Displays your current task.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}



