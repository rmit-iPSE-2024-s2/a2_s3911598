import XCTest
import SwiftUI
import SwiftData
@testable import a2_s3911598
final class CalendarViewTests: XCTestCase {

    func createMockMoods() -> [Mood] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"

        let mood1 = Mood(date: formatter.date(from: "2024/10/12")!, moodLevel: "Happy", notes: "Good day!")
        let mood2 = Mood(date: formatter.date(from: "2024/10/13")!, moodLevel: "Sad", notes: "Bad day!")
        let mood3 = Mood(date: formatter.date(from: "2024/10/14")!, moodLevel: "Neutral", notes: "")

        return [mood1, mood2, mood3]
    }

    func testMoodForDate_ReturnsCorrectMood() {
        // Arrange: Create CalendarView with injected mock mood data
        let sut = CalendarView(injectedMoods: createMockMoods())

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        // Act: Find the mood record for 2024/10/12
        let selectedDate = formatter.date(from: "2024/10/12")!
        let mood = sut.moodForDate(selectedDate)

        // Assert: Verify that the mood record exists and is "Happy"
        XCTAssertNotNil(mood, "A mood record should be found for 2024/10/12")
        XCTAssertEqual(mood?.moodLevel, "Happy", "The mood should be 'Happy'")
    }

    func testMoodForDate_NoMoodFound() {
        // Arrange: Create CalendarView with injected mock mood data
        let sut = CalendarView(injectedMoods: createMockMoods())
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"

        // Act: Find the mood record for a date with no record (2024/10/15)
        let selectedDate = formatter.date(from: "2024/12/15")!
        let mood = sut.moodForDate(selectedDate)

        // Assert: Verify that no mood record is found
        XCTAssertNil(mood, "No mood record should be found for 2024/10/15")
    }
    
    func testGenerateDaysInMonth_CorrectNumberOfDays() {
        let sut = CalendarView()
        let daysInOctober2024 = sut.generateDaysInMonth(for: Date(timeIntervalSince1970: 1727731200))

        // 29 days for February in a leap year, plus some padding at the start of the week
        XCTAssertEqual(daysInOctober2024.count, 32, "February 2020 should have 35 slots including leading padding days")
    }
    
    func testPreviousMonth() {
        // Arrange: Create a CalendarView and set a specific month (October 2024)
        let sut = CalendarView()
        let initialMonth = Date(timeIntervalSince1970: 1727731200) // October 2024

        // Act: Call previousMonth to go back to September 2024
        let previousMonth = sut.previousMonth(from: initialMonth)

        // Assert: Verify the currentMonth is now September 2024 using the monthYearString method
        let expectedMonth = "September 2024"
        XCTAssertEqual(sut.monthYearString(from: previousMonth!), expectedMonth, "The previous month should be September 2024.")
    }

    func testNextMonth() {
        // Arrange: Create a CalendarView and set a specific month (October 2024)
        let sut = CalendarView()
        let initialMonth = Date(timeIntervalSince1970: 1727731200) // October 2024

        // Act: Call nextMonth to move to November 2024
        let nextMonth = sut.nextMonth(from: initialMonth)

        // Assert: Verify the currentMonth is now November 2024 using the monthYearString method
        let expectedMonth = "November 2024"
        XCTAssertEqual(sut.monthYearString(from: nextMonth!), expectedMonth, "The next month should be November 2024.")
    }

    func testDayString() {
        // Arrange: Create a CalendarView and a specific date
        let sut = CalendarView()
        let testDate = Date(timeIntervalSince1970: 1727808000) // October 2, 2024

        // Act: Get the day string for the test date
        let dayString = sut.dayString(from: testDate)

        // Assert: Verify the day string is correct
        XCTAssertEqual(dayString, "2", "The day string should be '2'.")
    }

    func testMonthYearString() {
        // Arrange: Create a CalendarView and a specific date
        let sut = CalendarView()
        let testDate = Date(timeIntervalSince1970: 1727731200) // October 2024

        // Act: Get the month-year string for the test date
        let monthYearString = sut.monthYearString(from: testDate)

        // Assert: Verify the month-year string is correct
        XCTAssertEqual(monthYearString, "October 2024", "The month-year string should be 'October 2024'.")
    }

}

