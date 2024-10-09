import XCTest
import SwiftUI
import ViewInspector
@testable import a2_s3911598

// Extend DailyTaskView for inspection
extension DailyTaskView: Inspectable {}

final class DailyTaskViewTests: XCTestCase {
    
    func testTaskDisplay() throws {
        // Arrange: Mock tasks
        let mockTasks = [
            Task(title: "My Task", taskDescription: "Test task", time: Date(), sharedWith: ""),
            Task(title: "Shared Task", taskDescription: "Shared task", time: Date(), sharedWith: "friend@example.com")
        ]
        
        // Act: Initialize DailyTaskView
        let view = DailyTaskView(tasks: mockTasks)
        
        // Assert: Check if tasks are displayed in correct sections
        let myTaskSection = try view.inspect().find(text: "My Task")
        XCTAssertEqual(myTaskSection.string(), "My Task")
        
        let sharedTaskSection = try view.inspect().find(text: "Shared Task")
        XCTAssertEqual(sharedTaskSection.string(), "Shared Task")
    }
    
    func testCreateTaskButton() throws {
        // Arrange
        let view = DailyTaskView()
        
        // Act: Simulate button tap
        try view.inspect().find(button: "plus").tap()
        
        // Assert: Verify showingCreateTaskView is true
        XCTAssertTrue(view.showingCreateTaskView)
    }
    
    func testDeleteTask() throws {
        // Arrange: Create a mock task and view
        let mockTask = Task(title: "Task to Delete", taskDescription: "Delete this task", time: Date(), sharedWith: "")
        let view = DailyTaskView(tasks: [mockTask])
        
        // Act: Simulate delete action
        try view.inspect().find(button: "trash").tap()
        
        // Assert: Task should be deleted from the model context
        XCTAssertFalse(view.tasks.contains(where: { $0.title == "Task to Delete" }))
    }
}
