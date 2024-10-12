//
//  Friend.swift
//  a2_s3911598
//
//  Created by lea.Wang on 8/10/2024.
//

import SwiftData
import Foundation

/// The `Friend` class represents a friend with a name and email.
///
/// This class stores basic contact information for a friend.

@Model
class Friend {
    var name: String
    var email: String

    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
}

