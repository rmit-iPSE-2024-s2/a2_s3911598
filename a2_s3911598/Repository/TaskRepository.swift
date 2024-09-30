//
//  TaskRepository.swift
//  a2_s3911598
//
//  Created by Lea Wang on 29/9/2024.
//
import SwiftData
import Foundation

class TaskRepository {
    func fetchAllTasks(context: ModelContext) -> [Task] {
        let fetchDescriptor = FetchDescriptor<Task>()
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Error fetching tasks: \(error)")
            return []
        }
    }

    func addTask(context: ModelContext, title: String, description: String, time: Date, sharedWith: [String]) {
        let task = Task(title: title, description: description, time: time, sharedWith: sharedWith)
        context.insert(task)
        DataManager.shared.saveContext(context: context)
        print("Task added: \(task.title)")
    }

    func deleteTask(context: ModelContext, task: Task) {
        context.delete(task)
        DataManager.shared.saveContext(context: context)
    }
}

