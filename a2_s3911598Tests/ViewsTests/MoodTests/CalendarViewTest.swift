////
////  CalendarViewTest.swift
////  a2_s3911598Tests
////
////  Created by Lea Wang on 11/10/2024.
////
//
//import XCTest
//import SwiftUI
//import SwiftData
//@testable import a2_s3911598
//
//final class CalendarViewTests: XCTestCase {
//    
//    // Test environment setup properties
//    var modelContainer: ModelContainer!  // Holds the model data, configured for testing.
//    var modelContext: ModelContext!      // Provides access to the model data context for performing operations.
//
//    // Set up the test environment before each test method is run.
//    // This method initializes an in-memory model container and context,
//    // ensuring that the tests do not affect the actual database.
//    @MainActor
//    override func setUp() {
//        super.setUp()
//        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
//        modelContainer = try! ModelContainer(for: Task.self, configurations: configuration)
//        modelContext = modelContainer.mainContext
//    }
//
//    // Tear down the test environment after each test method is run.
//    // This method clears the model context and container to ensure a clean state for the next test.
//    @MainActor
//    override func tearDown() {
//        modelContext = nil
//        modelContainer = nil
//        super.tearDown()
//    }
//    
//    // Unit test for generating days in a month
//    func testGenerateDaysInMonth() {
//        // Create an instance of CalendarView
//        let calendarView = CalendarView()
//        
//        // Set the test date to October 1, 2023
//        let testDate = Calendar.current.date(from: DateComponents(year: 2023, month: 10, day: 1))!
//        
//        // Call the function to generate days
//        let days = calendarView.generateDaysInMonth(for: testDate)
//        
//        // Assert that the number of days is correct
//        let numberOfDays = days.compactMap { $0 }.count
//        XCTAssertEqual(numberOfDays, 31, "October 2023 should have 31 days.")
//        
//        // Check if the first date is correct
//        if let firstDate = days.compactMap({ $0 }).first {
//            let components = Calendar.current.dateComponents([.year, .month, .day], from: firstDate)
//            XCTAssertEqual(components.year, 2023)
//            XCTAssertEqual(components.month, 10)
//            XCTAssertEqual(components.day, 1)
//        } else {
//            XCTFail("The first date is nil.")
//        }
//    }
//    
//    // Unit test for monthYearString method
//    func testMonthYearString() {
//        let calendarView = CalendarView()
//        let testDate = Calendar.current.date(from: DateComponents(year: 2023, month: 10, day: 1))!
//        let monthYear = calendarView.monthYearString(from: testDate)
//        XCTAssertEqual(monthYear, "October 2023", "monthYearString should return 'October 2023'.")
//    }
//    
//    // Unit test for dayString method
//    func testDayString() {
//        let calendarView = CalendarView()
//        let testDate = Calendar.current.date(from: DateComponents(year: 2023, month: 10, day: 5))!
//        let dayStr = calendarView.dayString(from: testDate)
//        XCTAssertEqual(dayStr, "5", "dayString should return '5'.")
//    }
//    
//    // Unit test for navigating to the previous month
//    func testPreviousMonth() {
//        // Initialize CalendarView with default currentMonth
//        let testDate = Calendar.current.date(from: DateComponents(year: 2023, month: 5, day: 1))!
//        var calendarView = CalendarView()
//        
//        // Set the currentMonth to the test date
//        calendarView.currentMonth = testDate
//
//        // Call the method to navigate to the previous month
//        calendarView.previousMonth()
//
//        // Verify the result
//        let components = Calendar.current.dateComponents([.year, .month], from: calendarView.currentMonth)
//        XCTAssertEqual(components.year, 2023)
//        XCTAssertEqual(components.month, 4) // Should be April
//    }
//
//    func testNextMonth() {
//        // Initialize CalendarView with default currentMonth
//        let testDate = Calendar.current.date(from: DateComponents(year: 2023, month: 5, day: 1))!
//        var calendarView = CalendarView()
//        
//        // Set the currentMonth to the test date
//        calendarView.currentMonth = testDate
//
//        // Call the method to navigate to the next month
//        calendarView.nextMonth()
//
//        // Verify the result
//        let components = Calendar.current.dateComponents([.year, .month], from: calendarView.currentMonth)
//        XCTAssertEqual(components.year, 2023)
//        XCTAssertEqual(components.month, 6) // Should be June
//    }
//
//}
