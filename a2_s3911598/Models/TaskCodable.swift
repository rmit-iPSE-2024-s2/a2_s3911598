import Foundation

struct TaskCodable: Codable {
    let title: String
    let taskDescription: String
    let time: Date
    let sharedWith: [String]
    let isCompleted: Bool
    let imageData: Data?

    // Placeholder for the widget preview
    static var placeholder: TaskCodable {
        TaskCodable(
            title: "Sample Task",
            taskDescription: "This is a sample task description.",
            time: Date(),
            sharedWith: [],
            isCompleted: false,
            imageData: nil
        )
    }
}

