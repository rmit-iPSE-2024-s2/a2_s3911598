//
//  MoodViewModelTests.swift
//  a2_s3911598Tests
//
//  Created by Lea Wang on 11/10/2024.
//

import XCTest
import SwiftData
import SwiftUI
@testable import a2_s3911598

final class MoodViewModelTests: XCTestCase {
    
    // Test environment setup properties.
    var modelContainer: ModelContainer!  // Holds the model data, configured for testing.
    var modelContext: ModelContext!      // Provides access to the model data context for performing operations.
    var viewModel: MoodViewModel!        // The ViewModel instance being tested.

    // Set up the test environment before each test method is run.
    // This method initializes an in-memory model container and context,
    // ensuring that the tests do not affect the actual database.
    @MainActor
    override func setUp() {
        super.setUp()
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try! ModelContainer(for: Mood.self, Friend.self, configurations: configuration)
        modelContext = modelContainer.mainContext
        // Initialize the ViewModel with the test model context.
        viewModel = MoodViewModel(modelContext: modelContext)
    }
    
    // Tear down the test environment after each test method is run.
    // This ensures that any data or state from the previous test does not affect subsequent tests.
    @MainActor
    override func tearDown() {
        viewModel = nil  // Remove the ViewModel instance.
        modelContext = nil  // Clear the model context.
        modelContainer = nil  // Clear the model container.
        super.tearDown()
    }
    
    // Test the fetchMoodData method to ensure it correctly retrieves and sorts mood data.
    // Purpose: Verify that fetchMoodData properly retrieves mood records from the model context
    // and sorts them in the expected order (most recent first).
    @MainActor
    func testFetchMoodData() {
        // Arrange: Create two mood records, one for today and one for yesterday.
        let mood1 = Mood(date: Date(), moodLevel: "Pleasant", notes: "Feeling good")
        let mood2 = Mood(date: Date().addingTimeInterval(-86400), moodLevel: "Unpleasant", notes: "Had a bad day")
        modelContext.insert(mood1)
        modelContext.insert(mood2)
        try! modelContext.save()  // Save the moods into the in-memory context.
        
        // Act: Fetch mood data using the ViewModel.
        viewModel.fetchMoodData()
        
        // Assert: Verify that the fetched data matches the expected count and order.
        XCTAssertEqual(viewModel.moodData.count, 2, "There should be two mood records fetched.")
        XCTAssertEqual(viewModel.moodData[0].moodLevel, "Pleasant", "The most recent mood should be 'Pleasant'.")
        
        // This test ensures that fetchMoodData retrieves all saved moods and sorts them by date,
        // with the most recent mood appearing first. It provides confidence that users will see
        // their latest moods at the top of their mood history.
    }
    
    // Test the moodForToday method to ensure it correctly identifies today's mood.
    // Purpose: Verify that moodForToday retrieves a mood record for the current date, if it exists.
    // This ensures that the user can easily see the mood they recorded for today.
    @MainActor
    func testMoodForToday() {
        // Arrange: Create a mood record for today and one for yesterday.
        let todayMood = Mood(date: Date(), moodLevel: "Neutral", notes: "Just okay")
        let yesterdayMood = Mood(date: Date().addingTimeInterval(-86400), moodLevel: "Pleasant", notes: "Great day")
        modelContext.insert(todayMood)
        modelContext.insert(yesterdayMood)
        try! modelContext.save()  // Save the moods into the in-memory context.
        
        // Act: Fetch mood data to populate the ViewModel and then retrieve today's mood.
        viewModel.fetchMoodData()
        let mood = viewModel.moodForToday()
        
        // Assert: Verify that today's mood is retrieved correctly.
        XCTAssertNotNil(mood, "Today's mood should not be nil if there is a record for today.")
        XCTAssertEqual(mood?.moodLevel, "Neutral", "Today's mood level should be 'Neutral'.")
        XCTAssertEqual(mood?.notes, "Just okay", "Today's mood notes should be 'Just okay'.")
        
        // This test ensures that moodForToday returns the correct mood record for the current date.
        // It validates that users can access the mood they recorded for today without seeing older entries.
    }
    
    // Test the getMoodDescription method to ensure it provides appropriate descriptions for moods.
    // Purpose: Verify that getMoodDescription returns the correct description for known moods
    // and handles unknown moods gracefully.
    // This helps ensure that the app displays user-friendly descriptions.
    func testGetMoodDescription() {
        // Act & Assert: Test known mood descriptions.
        XCTAssertEqual(viewModel.getMoodDescription(for: "Pleasant"), "Pleasant", "The description for 'Pleasant' should be 'Pleasant'.")
        XCTAssertEqual(viewModel.getMoodDescription(for: "Very Unpleasant"), "Very Unpleasant", "The description for 'Very Unpleasant' should be 'Very Unpleasant'.")
        
        // Act & Assert: Test unknown mood descriptions.
        XCTAssertEqual(viewModel.getMoodDescription(for: "Unknown Mood"), "Unknown", "The description for an unknown mood should be 'Unknown'.")
        
        // This test ensures that getMoodDescription provides the correct text for each mood.
        // It also checks that the function can handle unexpected input gracefully, ensuring a smooth user experience.
    }
}
