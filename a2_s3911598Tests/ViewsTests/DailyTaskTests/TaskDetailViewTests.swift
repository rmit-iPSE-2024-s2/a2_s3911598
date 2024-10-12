import XCTest
import SwiftUI
import Combine
import SwiftData
@testable import a2_s3911598

final class TaskDetailViewTests: XCTestCase {
    
    // Test environment setup properties
    var modelContainer: ModelContainer!
    var modelContext: ModelContext!
    
    // Set up the test environment before each test method is run.
    // This method initializes an in-memory model container and context,
    // ensuring that the tests do not affect the actual database.
    @MainActor
    override func setUp() {
        super.setUp()
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try! ModelContainer(for: Task.self, configurations: configuration)
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
    let mockTask = Task(
        title: "Test Task",
        taskDescription: "Test Description",
        time: Date(),
        sharedWith: [],
        isCompleted: false
    )

    func testTaskCompletion() {
        // Arrange: Create a mock task
        modelContext.insert(mockTask)

        // Create the TaskDetailView and call markTaskCompleted directly
        var sut = TaskDetailView(task: mockTask,modelContext: modelContext )
        
        // Act: Simulate marking task as completed
        sut.markTaskCompleted()
        
        // Assert: Check if the task is marked as completed
        XCTAssertTrue(mockTask.isCompleted, "The task should be marked as completed.")
    }
    
    // Test a valid checkmark shape
    func testValidCheckmarkShape() {
        // Arrange: Define points that form a valid checkmark shape according to the current logic
        let points: [CGPoint] = [
            CGPoint(x: 0, y: 2),
            CGPoint(x: 1, y: 3),
            CGPoint(x: 2, y: 4),
            CGPoint(x: 3, y: 2),
            CGPoint(x: 4, y: 1)
        ]
        
        let sut = TaskDetailView(task: mockTask)
        
        // Act: Call isCheckmarkShape to check if the points form a checkmark
        let result = sut.isCheckmarkShape(points: points)
        print(result)
        
        // Assert: Should be true
        XCTAssertTrue(result, "Expected a valid checkmark shape.")
    }

    func testInvalidCheckmarkShape() {
        // Arrange: Define points that do not form a valid checkmark shape
        let points: [CGPoint] = [
            CGPoint(x: 0, y: 2),   // Start point
            CGPoint(x: 1, y: 3),   // Some upward movement
            CGPoint(x: 2, y: 2),   // Moves down but not much
            CGPoint(x: 3, y: 1),   // Goes down slightly
            CGPoint(x: 4, y: 2)    // Ends higher than the second half
        ]
        
        let sut = TaskDetailView(task: mockTask)
        
        // Act: Call isCheckmarkShape to check if the points form a checkmark
        let result = sut.isCheckmarkShape(points: points)
        print(result)
        
        // Assert: Should be false
        XCTAssertFalse(result, "Expected an invalid checkmark shape.")
    }
    
    func testInsufficientPoints() {
        // Arrange: Define too few points to form a valid checkmark shape
        let points: [CGPoint] = [
            CGPoint(x: 0, y: 2),
            CGPoint(x: 1, y: 3),
            CGPoint(x: 2, y: 4)   // Only 3 points provided
        ]
        
        let sut = TaskDetailView(task: mockTask)
        
        // Act: Call isCheckmarkShape to check if the points form a checkmark
        let result = sut.isCheckmarkShape(points: points)
        print(result)
        
        // Assert: Should be false because there are not enough points
        XCTAssertFalse(result, "Expected false due to insufficient points.")
    }

}

