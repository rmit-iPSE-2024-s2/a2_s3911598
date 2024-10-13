//
//  DateFormatter.swift
//  a1_s3911598
//
//  Created by Lea Wang on 27/8/2024.
//

import Foundation

/// A global instance of `DateFormatter` used throughout the app for formatting date and time.
/// The formatter is initialized with the current system time zone.
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeZone = TimeZone.current  // Use the system's time zone
    return formatter
}()

/// A function that configures the global `dateFormatter` with specified styles or a custom format
/// to return a formatted date string based on the current date or a custom date.
///
/// - Parameters:
///   - useCurrentDate: A Boolean flag indicating whether to use the current system date. Default is `true`.
///   - dateStyle: The style to format the date component of the output. Default is `.medium`.
///   - timeStyle: The style to format the time component of the output. Default is `.short`.
///   - customFormat: A custom date format string. If provided, it overrides the default date and time styles.
///
/// - Returns: A `String` representing the formatted date and time.
func configureDateFormatter(useCurrentDate: Bool = true, dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .short, customFormat: String? = nil) -> String {
    // If a custom format is specified, use it
    if let customFormat = customFormat {
        dateFormatter.dateFormat = customFormat
    } else {
        // Otherwise, use system-provided styles for date and time
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
    }
    
    // Set the date to format, using the current date if `useCurrentDate` is true
    let dateToFormat: Date
    if useCurrentDate {
        dateToFormat = Date()  // Use the system's current date and time
    } else {
        // Optionally, handle custom dates if passed in the future
        dateToFormat = Date()
    }

    // Return the formatted date string
    return dateFormatter.string(from: dateToFormat)
}
