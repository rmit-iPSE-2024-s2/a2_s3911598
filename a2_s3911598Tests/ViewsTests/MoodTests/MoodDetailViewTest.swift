//import XCTest
//import SwiftUI
//import SwiftData
//@testable import a2_s3911598
//
//final class MoodDetailViewTests: XCTestCase {
//    var modelContainer: ModelContainer!
//    var modelContext: ModelContext!
//    @State private var isActive: Bool = true
//    @State private var selectedMood: String = "Pleasant"
//
//    @MainActor
//    override func setUp() {
//        super.setUp()
//        // Create an in-memory model container for testing
//        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
//        modelContainer = try! ModelContainer(for: Mood.self, configurations: configuration)
//        modelContext = modelContainer.mainContext
//    }
//
//    @MainActor
//    override func tearDown() {
//        // Clean up
//        modelContext = nil
//        modelContainer = nil
//        super.tearDown()
//    }
//
//    // Test for the saveMood function
//    @MainActor
//    func testSaveMood() {
//        // Arrange
//        let view = MoodDetailView(
//            isActive: Binding(get: { self.isActive }, set: { self.isActive = $0 }),
//            selectedMood: Binding(get: { self.selectedMood }, set: { self.selectedMood = $0 })
//        )
//        view.setMoodTextForTesting("Feeling great today!") // Use the method to set moodText
//
//        // Act
//        view.saveMood()
//        
//        // Assert
//        let fetchDescriptor = FetchDescriptor<Mood>()
//        let savedMoods = try! modelContext.fetch(fetchDescriptor)
//        
//        XCTAssertEqual(savedMoods.count, 1, "There should be exactly one mood saved.")
//        XCTAssertEqual(savedMoods.first?.moodLevel, selectedMood, "The saved mood level should match the selected mood.")
//        XCTAssertEqual(savedMoods.first?.notes, "Feeling great today!", "The saved notes should match the mood text input.")
//        XCTAssertEqual(savedMoods.first?.date, view.currentDate, "The date of the saved mood should be the current date.")
//    }
//}
