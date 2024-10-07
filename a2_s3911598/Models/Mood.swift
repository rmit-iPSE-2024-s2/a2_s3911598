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
    var id: UUID
    @Attribute var date: Date
    @Attribute var moodLevel: String
    @Attribute var notes: String
    @Attribute var sharedWith: [String]
    
    init(id: UUID = UUID(),date: Date = Date(), moodLevel: String, notes: String = "", sharedWith: [String] = []) {
        self.id = id
        self.date = date
        self.moodLevel = moodLevel
        self.notes = notes
        self.sharedWith = sharedWith
    }
}



