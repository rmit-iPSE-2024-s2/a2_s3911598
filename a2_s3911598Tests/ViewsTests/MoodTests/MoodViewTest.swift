import XCTest
import SwiftData
import SwiftUI
@testable import a2_s3911598

final class MoodViewTests: XCTestCase {
    
    var mockProfile = Profile(
        id: "1",
        name: "Test User",
        email: "test@example.com",
        emailVerified: "true",
        picture: "nil",
        updatedAt: "nil"
    )

    // Test the logic of `moodForToday` when a mood is recorded for today.
    @MainActor
    func testMoodForToday_WithMultipleMoods_ReturnsTodayLatestMood() {
        // Arrange: Create multiple mock moods
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let today = Date()
        let earlierToday = Calendar.current.date(byAdding: .hour, value: -3, to: today)!
        let moodEarlierToday = Mood(date: earlierToday, moodLevel: "Calm", notes: "Relaxed")
        let moodToday = Mood(date: today, moodLevel: "Excited", notes: "Looking forward to something")
        let moodYesterday = Mood(date: yesterday, moodLevel: "Tired", notes: "Exhausted after work")

        // Act: Inject multiple moods, including moods from today
        let sut = MoodView(userProfile: mockProfile, injectedMoodData: [moodEarlierToday, moodToday,moodYesterday])

        // Assert: Verify that the most recent mood for today is returned
        XCTAssertEqual(sut.moodForToday(moodData: [moodEarlierToday,moodToday, moodYesterday])?.moodLevel, "Excited")
    }
    
    @MainActor
    func testMoodForToday_MultipleMoodsNoneForToday_ReturnsNil() {
        // Arrange: Create mock moods for different days, none of them today
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        let moodYesterday = Mood(date: yesterday, moodLevel: "Tired", notes: "Exhausted after work")
        let moodTwoDaysAgo = Mood(date: twoDaysAgo, moodLevel: "Happy", notes: "Had a great day")

        // Act: Inject multiple moods, but none for today
        let sut = MoodView(userProfile: mockProfile, injectedMoodData: [moodYesterday, moodTwoDaysAgo])

        // Assert: Verify that no mood is returned for today
        XCTAssertNil(sut.moodForToday(moodData: [moodYesterday, moodTwoDaysAgo]), "There should be no mood for today.")
    }
}
