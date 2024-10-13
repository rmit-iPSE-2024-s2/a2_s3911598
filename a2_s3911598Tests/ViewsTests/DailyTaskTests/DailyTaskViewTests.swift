import XCTest
import SwiftData
import SwiftUI
@testable import a2_s3911598

final class DailyTaskViewTests: XCTestCase {
    
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
    
    // Test the filtering of tasks into personal tasks and shared tasks.
    // Purpose: Verify that tasks are correctly categorized into "My Tasks" and "Shared Tasks"
    // based on whether they are shared with others.
    @MainActor
    func testTaskFiltering() {
        // Arrange: Create two tasks, one that is not shared and one that is shared with another user.
        let task1 = Task(title: "My Task", taskDescription: "Test task", time: Date(), sharedWith: [])
        let task2 = Task(title: "Shared Task", taskDescription: "Shared task", time: Date(), sharedWith: ["friend@example.com"])
        
        // Insert the tasks into the model context to simulate stored data.
        modelContext.insert(task1)
        modelContext.insert(task2)
        
        // Act: Create an instance of DailyTaskView and filter the tasks.
        let sut = DailyTaskView(modelContext: modelContext)
        let myTasks = sut.getMyTasks(from: [task1, task2])
        let sharedTasks = sut.getSharedTasks(from: [task1, task2])
        
        // Assert: Verify that the tasks are correctly filtered.
        XCTAssertEqual(myTasks.count, 1, "There should be 1 personal task.")
        XCTAssertEqual(sharedTasks.count, 1, "There should be 1 shared task.")
        XCTAssertEqual(myTasks.first?.title, "My Task", "The personal task should be 'My Task'.")
        XCTAssertEqual(sharedTasks.first?.title, "Shared Task", "The shared task should be 'Shared Task'.")
        
        // This test ensures that the DailyTaskView correctly separates tasks into
        // those that are only for the user and those that are shared with others.
        // It provides confidence that the task filtering logic functions as intended,
        // which is crucial for displaying the correct tasks to the user.
    }
    
    // Test the deletion of a task from the model context.
    // Purpose: Verify that the deleteTask method correctly removes a task from the context
    // and that the deleted task is no longer present in the stored data.
    @MainActor
    func testDeleteTask() {
        // Arrange: Create a task and insert it into the model context.
        let task = Task(title: "Task to Delete", taskDescription: "Delete this task", time: Date(), sharedWith: [])
        modelContext.insert(task)
        
        // Act: Create an instance of DailyTaskView and delete the task.
        let sut = DailyTaskView(modelContext: modelContext)
        sut.deleteTask(task)
        
        // Assert: Fetch all tasks from the context and verify that the deleted task is no longer present.
        let fetchDescriptor = FetchDescriptor<Task>()
        let tasksAfterDeletion = try! modelContext.fetch(fetchDescriptor)
        XCTAssertFalse(tasksAfterDeletion.contains { $0.title == "Task to Delete" },
                       "The task titled 'Task to Delete' should not be present after deletion.")
    }
}
