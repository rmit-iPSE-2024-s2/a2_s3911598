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
    formatter.timeZone = TimeZone.current // 使用系统时区
    return formatter
}()

// 合并真实日历和时间的格式化函数
func configureDateFormatter(useCurrentDate: Bool = true, dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .short, customFormat: String? = nil) -> String {
    // 如果指定了自定义格式，则使用该格式
    if let customFormat = customFormat {
        dateFormatter.dateFormat = customFormat
    } else {
        // 否则使用系统提供的样式
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = timeStyle
    }
    
    // 如果使用当前日期和时间，格式化输出
    let dateToFormat: Date
    if useCurrentDate {
        dateToFormat = Date()  // 使用系统当前日期和时间
    } else {
        // 这里可以根据需求指定其他日期，比如通过参数传递进来的日期
        dateToFormat = Date()
    }

    return dateFormatter.string(from: dateToFormat)
}




