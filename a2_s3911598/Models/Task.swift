//
//  Task.swift
//  a1_s3911598
//
//  Created by Lea Wang on 27/8/2024.
//

import SwiftData
import Foundation

@Model
class Task {
    var title: String
    var taskDescription: String
    var time: Date
    var sharedWith: [String]
    var isCompleted: Bool
    var imageData: Data?

    init(title: String, taskDescription: String, time: Date, sharedWith: [String] = [], isCompleted: Bool = false,imageData: Data? = nil) {
        self.title = title
        self.taskDescription = taskDescription
        self.time = time
        self.sharedWith = sharedWith
        self.isCompleted = isCompleted
        self.imageData = imageData
    }
}




