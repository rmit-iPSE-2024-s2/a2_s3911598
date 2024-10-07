//
//  CurrentTaskWidget.swift
//  CurrentTaskWidget
//
//  Created by zachary.zhao on 7/10/2024.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TaskEntry {
        // Provide a placeholder task for the widget gallery
        TaskEntry(date: Date(), task: TaskCodable.placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (TaskEntry) -> Void) {
        // Provide a snapshot for the widget
        let entry = TaskEntry(date: Date(), task: getCurrentTask())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TaskEntry>) -> Void) {
        // Generate a timeline consisting of a single entry
        let currentDate = Date()
        let entry = TaskEntry(date: currentDate, task: getCurrentTask())

        // Refresh after 15 minutes or when you expect the data to change
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!

        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        completion(timeline)
    }
}


struct TaskEntry: TimelineEntry {
    let date: Date
    let task: TaskCodable?
}

func getCurrentTask() -> TaskCodable? {
    if let sharedDefaults = UserDefaults(suiteName: "group.com.a2-s3911598.a2-s3911598") {
        if let taskData = sharedDefaults.data(forKey: "currentTask"),
           let taskCodable = try? JSONDecoder().decode(TaskCodable.self, from: taskData) {
            return taskCodable
        }
    }
    return nil
}



struct CurrentTaskWidgetEntryView: View {
    var entry: TaskEntry

    var body: some View {
        if let task = entry.task {
            VStack(alignment: .leading, spacing: 5) {
                Text(task.title)
                    .font(.headline)
                    .bold()
                Text(task.taskDescription)
                    .font(.subheadline)
                    .lineLimit(2)
            }
            .padding()
        } else {
            Text("No current task")
                .padding()
        }
    }
}


struct CurrentTaskWidget: Widget {
    let kind: String = "CurrentTaskWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CurrentTaskWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Current Task")
        .description("Displays your current task.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}



