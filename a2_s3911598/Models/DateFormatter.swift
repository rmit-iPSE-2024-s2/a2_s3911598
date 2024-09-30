//
//  DateFormatter.swift
//  a1_s3911598
//
//  Created by Lea Wang on 27/8/2024.
//

import Foundation

// Define a global date formatting tool
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    return formatter
}()

// set date function
func configureDateFormatter(dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .none) {
    dateFormatter.dateStyle = dateStyle
    dateFormatter.timeStyle = timeStyle
}

// set date formatter
func configureDateFormatter(withFormat format: String) {
    dateFormatter.dateFormat = format
}



