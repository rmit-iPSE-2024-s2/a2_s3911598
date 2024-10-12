import XCTest
import SwiftUI
import SwiftData
@testable import a2_s3911598

final class CreateTaskViewTests: XCTestCase {
    
    // Test environment setup properties
    var modelContainer: ModelContainer!  // Holds the model data, configured for testing.
    var modelContext: ModelContext!      // Provides access to the model data context for performing operations.
    @State private var isPresented = false
    
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
    
    // Test task creation with valid input
    @MainActor
    func testTaskCreation() {
        // Arrange: Set up test input values
        let sut = CreateTaskView(isPresented: $isPresented)
        sut.title = "Test Task"
        sut.description = "This is a test task description"
        sut.time = Date()
        
        // Act: Save the task
        sut.saveTask()
        
        // Assert: Verify the task was inserted into the model context
        let fetchDescriptor = FetchDescriptor<Task>()
        let tasks = try! modelContext.fetch(fetchDescriptor)
        XCTAssertEqual(tasks.count, 1, "There should be 1 task created.")
        XCTAssertEqual(tasks.first?.title, "Test Task", "The task title should be 'Test Task'.")
        XCTAssertEqual(tasks.first?.taskDescription, "This is a test task description", "The task description should match.")
    }
    
    // Test empty title validation
    @MainActor
    func testEmptyTitleValidation() {
        // Arrange: Set up test input with empty title
        let sut = CreateTaskView(isPresented: $isPresented)
        sut.description = "This is a test task description"
        sut.time = Date()
        
        // Act: Attempt to save the task
        sut.saveTask()
        
        // Assert: Ensure task was not inserted due to empty title
        let fetchDescriptor = FetchDescriptor<Task>()
        let tasks = try! modelContext.fetch(fetchDescriptor)
        XCTAssertEqual(tasks.count, 0, "No tasks should be created with an empty title.")
    }
    
    // Test that the task is saved with selected friends
    @MainActor
    func testTaskWithFriends() {
        // Arrange: Set up test input with friends
        let friend = Friend(name: "John Doe", email: "John@gmail.com")
        let sut = CreateTaskView(isPresented: $isPresented)
        sut.title = "Team Task"
        sut.description = "A task with a friend"
        sut.time = Date()
        sut.selectedFriends = [friend]
        
        // Act: Save the task
        sut.saveTask()
        
        // Assert: Verify that the task includes the selected friend
        let fetchDescriptor = FetchDescriptor<Task>()
        let tasks = try! modelContext.fetch(fetchDescriptor)
        XCTAssertEqual(tasks.first?.sharedWith, ["John Doe"], "The task should be shared with 'John Doe'.")
    }
    
}

