import SwiftUI
import SwiftData

/// The `TaskDetailView` struct displays detailed information about a task, including the title, description, time, collaborators, and task status.
///
/// The view also includes an interactive drawing area where users can draw a checkmark to mark the task as completed.
struct TaskDetailView: View {
    
    /// The environment's model context for managing task data.
    @Environment(\.modelContext) private var modelContext
    
    /// The task whose details are being displayed.
    @State private var task: Task
    
    /// Stores points drawn by the user for the checkmark gesture.
    @State private var drawingPoints: [CGPoint] = []
    
    /// Tracks whether the long press gesture is active.
    @State private var isLongPressActive = false
    
    /// Optional injected model context (for testing or dependency injection).
    private var injectedModelContext: ModelContext?

    /// Initializes the `TaskDetailView` with the task to be displayed and an optional model context.
    ///
    /// - Parameters:
    ///   - task: The task to display.
    ///   - modelContext: Optional model context for managing task data (default: nil).
    init(task: Task, modelContext: ModelContext? = nil) {
        _task = State(initialValue: task)
        self.injectedModelContext = modelContext
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // Task title
            Text("Title:")
                .font(.custom("Chalkboard SE", size: 18))
                .padding(.leading, 16)
            Text(task.title)
                .font(.custom("Chalkboard SE", size: 16))
                .padding([.leading], 16)
                .padding([.top], -10)

            // Task description
            Text("Description:")
                .font(.custom("Chalkboard SE", size: 18))
                .padding(.leading, 16)
            Text(task.taskDescription)
                .font(.custom("Chalkboard SE", size: 16))
                .padding(.leading, 16)
                .padding([.top], -10)
            
            // Task image (if available)
            if let imageData = task.imageData, let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 100)
                    .clipped()
                    .cornerRadius(10)
                    .padding(.horizontal)
            }

            // Task time
            Text("Time:")
                .font(.custom("Chalkboard SE", size: 18))
                .padding(.leading, 16)
            Text(task.time, style: .time)
                .font(.custom("Chalkboard SE", size: 16))
                .padding(.leading, 16)
                .padding([.top], -10)

            // Collaborators (if any)
            if !task.sharedWith.isEmpty {
                Text("Shared With:")
                    .font(.custom("Chalkboard SE", size: 18))
                    .padding(.leading, 16)
                Text(task.sharedWith.joined(separator: ", "))
                    .font(.custom("Chalkboard SE", size: 16))
                    .padding(.leading, 16)
                    .padding([.top], -10)
            }

            // Task status
            Text("Status:")
                .font(.custom("Chalkboard SE", size: 18))
                .padding(.leading, 16)
            Text(task.isCompleted ? "Completed" : "Not Completed")
                .font(.custom("Chalkboard SE", size: 16))
                .padding(.leading, 16)
                .padding([.top], -10)
                .foregroundColor(task.isCompleted ? .green : .red)

            // Drawing area for checkmark
            ZStack {
                Rectangle()
                    .fill(Color(white: 1))
                    .cornerRadius(10)

                // Draw the user's gesture path
                if !drawingPoints.isEmpty {
                    Path { path in
                        path.addLines(drawingPoints)
                    }
                    .stroke(Color.green, lineWidth: 4)
                }
            }
            .contentShape(Rectangle())
            .gesture(
                LongPressGesture(minimumDuration: 0.5)
                    .onEnded { _ in
                        isLongPressActive = true
                    }
                    .sequenced(before:
                        DragGesture(minimumDistance: 0, coordinateSpace: .named("drawingArea"))
                            .onChanged { value in
                                if isLongPressActive {
                                    drawingPoints.append(value.location)
                                }
                            }
                            .onEnded { _ in
                                if isLongPressActive {
                                    if isCheckmarkShape(points: drawingPoints) {
                                        markTaskCompleted()
                                    }
                                    drawingPoints.removeAll()
                                    isLongPressActive = false
                                }
                            }
                    )
            )
            .frame(height: 200)
            .padding()
            .coordinateSpace(name: "drawingArea")

            Spacer()
        }
        .navigationBarTitle("Task Details", displayMode: .inline)
    }

    /// Marks the task as completed and updates the task in the model context.
    func markTaskCompleted() {
        task.isCompleted = true
        let context = injectedModelContext ?? modelContext
        context.insert(task)
    }

    /// Determines if the user's drawn points form a checkmark shape.
    ///
    /// - Parameter points: The list of points drawn by the user.
    /// - Returns: `true` if the points resemble a checkmark shape, otherwise `false`.
    func isCheckmarkShape(points: [CGPoint]) -> Bool {
        // Simplified checkmark detection logic
        guard points.count >= 5 else {
            return false
        }

        let startPoint = points.first!
        let endPoint = points.last!
        let totalDeltaX = endPoint.x - startPoint.x
        let totalDeltaY = endPoint.y - startPoint.y

        guard totalDeltaX > 0, totalDeltaY < 0 else {
            return false
        }

        let midIndex = points.count / 2
        let firstHalf = Array(points[0...midIndex])
        let secondHalf = Array(points[midIndex...])

        let firstStart = firstHalf.first!
        let firstEnd = firstHalf.last!
        let firstDeltaX = firstEnd.x - firstStart.x
        let firstDeltaY = firstEnd.y - firstStart.y

        guard firstDeltaX > 0, firstDeltaY > 0 else {
            return false
        }

        let secondStart = secondHalf.first!
        let secondEnd = secondHalf.last!
        let secondDeltaX = secondEnd.x - secondStart.x
        let secondDeltaY = secondEnd.y - secondStart.y

        guard secondDeltaX > 0, secondDeltaY < 0 else {
            return false
        }

        return true
    }
}
