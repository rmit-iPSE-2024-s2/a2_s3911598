//
//  CalendarViewTest.swift
//  a2_s3911598Tests
//
//  Created by Lea Wang on 11/10/2024.
//

import XCTest
import SwiftUI
import SwiftData
@testable import a2_s3911598

final class CalendarViewTests: XCTestCase {
    
    func testGenerateDaysInMonth() {
        // 创建 CalendarView 实例
        let calendarView = CalendarView()
        
        // 设置测试日期为 2023 年 10 月 1 日
        let testDate = Calendar.current.date(from: DateComponents(year: 2023, month: 10, day: 1))!
        
        // 调用函数
        let days = calendarView.generateDaysInMonth(for: testDate)
        
        // 断言天数是否正确
        let numberOfDays = days.compactMap { $0 }.count
        XCTAssertEqual(numberOfDays, 31, "2023 年 10 月应有 31 天")
        
        // 检查第一个日期是否正确
        if let firstDate = days.compactMap({ $0 }).first {
            let components = Calendar.current.dateComponents([.year, .month, .day], from: firstDate)
            XCTAssertEqual(components.year, 2023)
            XCTAssertEqual(components.month, 10)
            XCTAssertEqual(components.day, 1)
        } else {
            XCTFail("第一个日期为 nil")
        }
    }
    
    func testMonthYearString() {
        let calendarView = CalendarView()
        let testDate = Calendar.current.date(from: DateComponents(year: 2023, month: 10, day: 1))!
        let monthYear = calendarView.monthYearString(from: testDate)
        XCTAssertEqual(monthYear, "October 2023", "monthYearString 应返回 'October 2023'")
    }
    
    func testDayString() {
        let calendarView = CalendarView()
        let testDate = Calendar.current.date(from: DateComponents(year: 2023, month: 10, day: 5))!
        let dayStr = calendarView.dayString(from: testDate)
        XCTAssertEqual(dayStr, "5", "dayString 应返回 '5'")
    }
    
    func testPreviousMonth() {
            // 初始化 CalendarView，传入特定的 currentMonth
            let testDate = Calendar.current.date(from: DateComponents(year: 2023, month: 5, day: 1))!
            var calendarView = CalendarView(currentMonth: testDate)

            // 调用方法
            calendarView.previousMonth()

            // 验证结果
            let components = Calendar.current.dateComponents([.year, .month], from: calendarView.testCurrentMonth)
            XCTAssertEqual(components.year, 2023)
            XCTAssertEqual(components.month, 4) // 应该是 4 月
        }

    func testNextMonth() {
            let testDate = Calendar.current.date(from: DateComponents(year: 2023, month: 5, day: 1))!
            var calendarView = CalendarView(currentMonth: testDate)

            // 调用方法
            calendarView.nextMonth()

            // 验证结果
            let components = Calendar.current.dateComponents([.year, .month], from: calendarView.testCurrentMonth)
            XCTAssertEqual(components.year, 2023)
            XCTAssertEqual(components.month, 6) // 应该是 6 月
        }
    }
