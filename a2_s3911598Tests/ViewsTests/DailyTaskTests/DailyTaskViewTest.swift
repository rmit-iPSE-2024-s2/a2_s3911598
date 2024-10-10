import XCTest
import SwiftData
import SwiftUI
@testable import a2_s3911598

final class DailyTaskViewTests: XCTestCase {
    
    var modelContainer: ModelContainer!
    var modelContext: ModelContext!
    
    @MainActor
    override func setUp() {
        super.setUp()
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try! ModelContainer(for: Task.self, configurations: configuration)
        modelContext = modelContainer.mainContext
    }


    
    @MainActor
    override func tearDown() {
        modelContext = nil
        modelContainer = nil
        super.tearDown()
    }
    
    @MainActor
    func testTaskFiltering() {
        // Arrange
        let task1 = Task(title: "My Task", taskDescription: "Test task", time: Date(), sharedWith: [])
        let task2 = Task(title: "Shared Task", taskDescription: "Shared task", time: Date(), sharedWith: ["friend@example.com"])
        
        // Act
        let sut = DailyTaskView(testTasks: [task1, task2])
        
        let myTasks = sut.getMyTasks(from: [task1, task2])
        let sharedTasks = sut.getSharedTasks(from: [task1, task2])
        
        // Assert
        XCTAssertEqual(myTasks.count, 1)
        XCTAssertEqual(sharedTasks.count, 1)
        XCTAssertEqual(myTasks.first?.title, "My Task")
        XCTAssertEqual(sharedTasks.first?.title, "Shared Task")
    }
    
    @MainActor
    func testDeleteTask() {
        // Arrange
        let task = Task(title: "Task to Delete", taskDescription: "Delete this task", time: Date(), sharedWith: [])
        modelContext.insert(task)
        
        // Act
        let sut = DailyTaskView(testTasks: [task], modelContext: modelContext)
        sut.deleteTask(task)
        
        // Assert
        let fetchDescriptor = FetchDescriptor<Task>()
        let tasksAfterDeletion = try! modelContext.fetch(fetchDescriptor)
        XCTAssertFalse(tasksAfterDeletion.contains { $0.title == "Task to Delete" })
    }
}




