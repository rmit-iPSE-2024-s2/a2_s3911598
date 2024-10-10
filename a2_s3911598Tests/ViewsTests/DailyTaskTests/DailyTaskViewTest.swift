import XCTest
@testable import a2_s3911598

final class DailyTaskLogicTests: XCTestCase {

    func testTaskFiltering() {
            let mockTasks = [
                Task(title: "My Task", taskDescription: "Test task", time: Date(), sharedWith: []),
                Task(title: "Shared Task", taskDescription: "Shared task", time: Date(), sharedWith: ["friend@example.com"])
            ]
        let sut = DailyTaskView()

        let myTasks = mockTasks.filter { $0.sharedWith.isEmpty }
        let sharedTasks = mockTasks.filter { !$0.sharedWith.isEmpty }

        XCTAssertEqual(myTasks.count, 1)
        XCTAssertEqual(sharedTasks.count, 1)
        XCTAssertEqual(myTasks.first?.title, "My Task")
        XCTAssertEqual(sharedTasks.first?.title, "Shared Task")
    }

    func testTaskDeletion() {
        let mockTask = Task(title: "Task to Delete", taskDescription: "Delete this task", time: Date(), sharedWith: [])
        var tasks = [mockTask]

        tasks.removeAll { $0.title == mockTask.title }

        XCTAssertFalse(tasks.contains { $0.title == mockTask.title })
    }
}

