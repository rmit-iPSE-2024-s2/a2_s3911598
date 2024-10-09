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
    formatter.timeZone = TimeZone.current // Use the system timezone
    return formatter
}()

// Combine date and time formatting functions
func configureDateFormatter(useCurrentDate: Bool = true, dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .short, customFormat: String? = nil) -> String {
    // If a custom format is specified, use it
    if let customFormat = customFormat {
        dateFormatter.dateFormat = customFormat
    } else {
        // Otherwise, use system-provided styles
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
    }
    
    // If using the current date and time, format the output
    let dateToFormat: Date
    if useCurrentDate {
        dateToFormat = Date()  // Use the system's current date and time
    } else {
        // Here, other dates can be specified as needed, such as those passed in as parameters
        dateToFormat = Date()
    }

    return dateFormatter.string(from: dateToFormat)
}
