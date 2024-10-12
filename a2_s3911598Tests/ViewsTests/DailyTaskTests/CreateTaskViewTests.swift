import XCTest
import SwiftUI
import SwiftData
@testable import a2_s3911598

final class CreateTaskViewTests: XCTestCase {
    
    // Test environment setup properties
    var modelContainer: ModelContainer!
    var modelContext: ModelContext!
    var testDefaults: UserDefaults!
    
    // Set up the test environment before each test method is run.
    // This method initializes an in-memory model container and context,
    // ensuring that the tests do not affect the actual database.
    @MainActor
    override func setUp() {
        super.setUp()
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try! ModelContainer(for: Task.self, configurations: configuration)
        modelContext = modelContainer.mainContext
        
        testDefaults = UserDefaults(suiteName: "test.suite.name")
        testDefaults.removePersistentDomain(forName: "test.suite.name")
    }
    
    // Tear down the test environment after each test method is run.
    // This method clears the model context and container to ensure a clean state for the next test.
    @MainActor
    override func tearDown() {
        modelContext = nil
        modelContainer = nil
        testDefaults = nil
        super.tearDown()
    }
    
    // Test task creation with valid input
    @MainActor
    func testTaskCreationWithoutFriend() {
        // Arrange: Create a view with specific test values
        let sut = CreateTaskView(
            isPresented: .constant(false),
            title: "Test Task",
            description: "Test Description",
            time: Date(),
            modelContext: modelContext  // Inject the test model context
        )

        // Act: Simulate saving the task
        sut.saveTask()

        // Assert: Verify the task was saved correctly in the test context
        let fetchDescriptor = FetchDescriptor<Task>()
        let tasks = try! modelContext.fetch(fetchDescriptor)
        XCTAssertEqual(tasks.count, 1, "There should be 1 task created.")
        XCTAssertEqual(tasks.first?.title, "Test Task", "The task title should be 'Test Task'.")
        XCTAssertEqual(tasks.first?.taskDescription, "Test Description", "The task description should match.")
    }
    
    func testTaskCreationWithFriend() {
        // Arrange: Create a view with specific test values
        let sut = CreateTaskView(
            isPresented: .constant(false),
            title: "Test Task",
            description: "Test Description",
            time: Date(),
            selectedFriends: [Friend(name: "Test Friend", email: "Test@gmail.com")],
            modelContext: modelContext  // Inject the test model context
        )

        // Act: Simulate saving the task
        sut.saveTask()

        // Assert: Verify the task was saved correctly in the test context
        let fetchDescriptor = FetchDescriptor<Task>()
        let tasks = try! modelContext.fetch(fetchDescriptor)
        XCTAssertEqual(tasks.count, 1, "There should be 1 task created.")
        XCTAssertEqual(tasks.first?.title, "Test Task", "The task title should be 'Test Task'.")
        XCTAssertEqual(tasks.first?.taskDescription, "Test Description", "The task description should match.")
        XCTAssertEqual(tasks.first?.sharedWith, ["Test Friend"])
    }
    
    @MainActor
    func testEmptyTitleValidation() {
        // Arrange: Set up test input with empty title
        let sut = CreateTaskView(
            isPresented: .constant(false),
            description: "Test Description",
            time: Date(),
            selectedFriends: [Friend(name: "Test Friend", email: "Test@gmail.com")],
            modelContext: modelContext
        )
        
        // Act: Attempt to save the task
        sut.saveTask()
        
        // Assert: Ensure task was not inserted due to empty title
        let fetchDescriptor = FetchDescriptor<Task>()
        let tasks = try! modelContext.fetch(fetchDescriptor)
        XCTAssertEqual(tasks.count, 0, "No tasks should be created with an empty title.")
    }
    
    @MainActor
    func testSaveTaskToUserDefaults() {
        // Arrange: Set up test in-memory UserDefaults
        let testDefaults = UserDefaults(suiteName: "test.suite.name")
        testDefaults?.removePersistentDomain(forName: "test.suite.name")

        // Arrange: Create a view with specific test values
        let sut = CreateTaskView(
            isPresented: .constant(false),
            title: "Test Task",
            description: "Test Description",
            time: Date(),
            modelContext: modelContext,  // Inject the test model context
            userDefaults: testDefaults   // Inject the in-memory UserDefaults
        )

        // Act: Simulate saving the task
        sut.saveTask()

        // Assert: Check if the task was saved correctly to UserDefaults
        if let taskData = testDefaults?.data(forKey: "currentTask") {
            let decoder = JSONDecoder()
            let savedTask = try? decoder.decode(TaskCodable.self, from: taskData)

            XCTAssertNotNil(savedTask, "The task should be saved in UserDefaults.")
            XCTAssertEqual(savedTask?.title, "Test Task", "The saved task title should be 'Test Task'.")
            XCTAssertEqual(savedTask?.taskDescription, "Test Description", "The saved task description should be 'Test Description'.")
        } else {
            XCTFail("Task data not found in UserDefaults.")
        }
    }
}

