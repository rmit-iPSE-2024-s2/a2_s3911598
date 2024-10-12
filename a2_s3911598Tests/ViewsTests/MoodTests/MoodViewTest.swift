////
////  MoodViewTests.swift
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
//final class MoodViewTests: XCTestCase {
//    
//    // Test environment setup properties.
//    var modelContainer: ModelContainer!
//    var modelContext: ModelContext!
//    @State private var selectedFriends: [Friend] = []
//    @State private var isActive: Bool = true
//
//    @MainActor
//    override func setUp() {
//        super.setUp()
//        // Create an in-memory model container for testing.
//        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
//        modelContainer = try! ModelContainer(for: Mood.self, Friend.self, configurations: configuration)
//        modelContext = modelContainer.mainContext
//    }
//    
//    @MainActor
//    override func tearDown() {
//        modelContext = nil
//        modelContainer = nil
//        super.tearDown()
//    }
//
//    // Test the moodForToday method to ensure it correctly identifies today's mood.
//    @MainActor
//    func testMoodForToday() {
//        // Arrange: Create a mood record for today.
//        let todayMood = Mood(date: Date(), moodLevel: "Neutral", notes: "Just okay")
//        modelContext.insert(todayMood)
//        try! modelContext.save()
//
//        // Create a Profile instance with all required parameters.
//        let userProfile = Profile(
//            id: "12345",
//            name: "Test User",
//            email: "testuser@example.com",
//            emailVerified: "true",
//            picture: "https://example.com/profile.jpg",
//            updatedAt: "2024-10-11T12:34:56Z"
//        )
//
//        // Create an instance of MoodView.
//        let moodView = MoodView(
//            userProfile: userProfile,
//            modelContext: modelContext
//        )
//        
//        // Act: Get today's mood.
//        let result = moodView.moodForToday()
//        
//        // Assert: Check that the returned mood matches today's mood.
//        XCTAssertNotNil(result, "Today's mood should not be nil if there is a record for today.")
//        XCTAssertEqual(result?.moodLevel, "Neutral", "The mood level should be 'Neutral'.")
//        XCTAssertEqual(result?.notes, "Just okay", "The mood notes should match 'Just okay'.")
//    }
//    
//    // Test the getMoodDescription method to ensure it provides the correct descriptions.
//    func testGetMoodDescription() {
//        // Arrange: Create a Profile instance with all required parameters.
//        let userProfile = Profile(
//            id: "12345",
//            name: "Test User",
//            email: "testuser@example.com",
//            emailVerified: "true",
//            picture: "https://example.com/profile.jpg",
//            updatedAt: "2024-10-11T12:34:56Z"
//        )
//
//        // Create an instance of MoodView.
//        let moodView = MoodView(
//            userProfile: userProfile,
//            modelContext: modelContext
//        )
//        
//        // Act & Assert: Test known mood descriptions.
//        XCTAssertEqual(moodView.getMoodDescription(for: "Pleasant"), "Pleasant", "The description for 'Pleasant' should be 'Pleasant'.")
//        XCTAssertEqual(moodView.getMoodDescription(for: "Very Unpleasant"), "Very Unpleasant", "The description for 'Very Unpleasant' should be 'Very Unpleasant'.")
//        
//        // Act & Assert: Test unknown mood descriptions.
//        XCTAssertEqual(moodView.getMoodDescription(for: "Unknown Mood"), "Unknown", "The description for an unknown mood should be 'Unknown'.")
//    }
//}
