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
    @Attribute var date: Date
    @Attribute var moodLevel: Int
    @Attribute var notes: String
    @Attribute var sharedWith: [String]
    
    init(date: Date = Date(), moodLevel: Int, notes: String = "", sharedWith: [String] = []) {
        self.date = date
        self.moodLevel = moodLevel
        self.notes = notes
        self.sharedWith = sharedWith
    }
}



