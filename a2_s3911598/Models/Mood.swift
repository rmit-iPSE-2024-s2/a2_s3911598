//
//  Mood.swift
//  a2_s3911598
//
//  Created by Lea Wang on 2/10/2024.
//

import Foundation
import SwiftData

@Model
class Mood {
    var date: Date
     var moodLevel: String
     var notes: String
     var sharedWith: [String]
    
    init(id: UUID = UUID(),date: Date = Date(), moodLevel: String, notes: String = "", sharedWith: [String] = []) {
        self.date = date
        self.moodLevel = moodLevel
        self.notes = notes
        self.sharedWith = sharedWith
    }
}



