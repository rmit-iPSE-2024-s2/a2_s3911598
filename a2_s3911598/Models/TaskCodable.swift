//
//  RandomActivity.swift
//  a2_s3911598
//
//  Created by lea.Wang on 7/10/2024.
//


import Foundation

/// A codable representation of a task, suitable for encoding and decoding.
///
/// This struct includes properties for the task's title, description, scheduled time, shared recipients, completion status, and associated image data.
struct TaskCodable: Codable {
    
    /// The title of the task.
    let title: String
    
    /// A detailed description of the task.
    let taskDescription: String
    
    /// The scheduled time for the task.
    let time: Date
    
    /// An array of strings representing individuals the task is shared with.
    let sharedWith: [String]
    
    /// A boolean indicating whether the task has been completed.
    let isCompleted: Bool
    
    /// Optional data for an image associated with the task.
    let imageData: Data?
    
    /// Provides a placeholder `TaskCodable` instance for preview purposes.
    ///
    /// - Returns: A `TaskCodable` instance with sample data.
    static var placeholder: TaskCodable {
        TaskCodable(
            title: "Sample Task",
            taskDescription: "This is a sample task description.",
            time: Date(),
            sharedWith: [],
            isCompleted: false,
            imageData: nil
        )
    }
}


