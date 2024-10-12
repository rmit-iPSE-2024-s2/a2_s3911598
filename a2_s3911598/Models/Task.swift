//
//  Task.swift
//  a1_s3911598
//
//  Created by Lea Wang on 27/8/2024.
//

import SwiftData
import Foundation

/// The `Task` class represents a task with a title, description, time, and other details.
///
/// This class tracks the task's title, description, scheduled time, completion status, sharing details, and any associated image.
@Model
class Task {
    
    // The title of the task.
    var title: String
    
    //A detailed description of the task.
    var taskDescription: String
    
    // The scheduled time of the task.
    var time: Date
    
    // A list of people the task is shared with.
    var sharedWith: [String]
    
    // A boolean value indicating whether the task is completed.
    var isCompleted: Bool
    
    // Optional image data associated with the task.
    var imageData: Data?
    
   
    ///
    /// - Parameters:
    ///   - title: The title of the task.
    ///   - taskDescription: A detailed description of the task.
    ///   - time: The scheduled time of the task.
    ///   - sharedWith: A list of people the task is shared with (default: empty array).
    ///   - isCompleted: A boolean indicating if the task is completed (default: false).
    ///   - imageData: Optional image data for the task (default: nil).
    init(title: String, taskDescription: String, time: Date, sharedWith: [String] = [], isCompleted: Bool = false, imageData: Data? = nil) {
        self.title = title
        self.taskDescription = taskDescription
        self.time = time
        self.sharedWith = sharedWith
        self.isCompleted = isCompleted
        self.imageData = imageData
    }
}





