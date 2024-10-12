import XCTest
import SwiftData
import SwiftUI
@testable import a2_s3911598

final class MoodViewTests: XCTestCase {

    // Test environment setup properties
    var modelContainer: ModelContainer!  // Holds the model data, configured for testing.
    var modelContext: ModelContext!      // Provides access to the model data context for performing operations.

    // Set up the test environment before each test method is run.
    // This method initializes an in-memory model container and context,
    // ensuring that the tests do not affect the actual database.
    @MainActor
    override func setUp() {
        super.setUp()
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try! ModelContainer(for: Mood.self, configurations: configuration)
        modelContext = modelContainer.mainContext
    }

    // Tear down the test environment after each test method is run.
    // This method clears the model context and container to ensure a clean state for the next test.
    @MainActor
    override func tearDown() {
        modelContext = nil
        modelContainer = nil
        super.tearDown()
    }
    
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
