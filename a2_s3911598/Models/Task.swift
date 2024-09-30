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
    @Attribute var title: String
    @Attribute var taskDescription: String
    @Attribute var time: Date
    @Attribute var sharedWith: [String]
    @Attribute var isCompleted: Bool
    
    init(title: String, description: String = "", time: Date = Date(), sharedWith: [String] = [], isCompleted: Bool = false) {
        self.title = title
        self.taskDescription = description
        self.time = time
        self.sharedWith = sharedWith
        self.isCompleted = isCompleted
    }
}



