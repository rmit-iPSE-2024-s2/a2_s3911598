import SwiftUI

struct TaskDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var task: Task
    @State private var drawingPoints: [CGPoint] = []
    @State private var isLongPressActive = false

    init(task: Task) {
        _task = State(initialValue: task)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Task details
            Text(task.title)
                .font(.custom("Chalkboard SE", size: 24))
                .padding([.top, .leading], 16)

            Text("Description:")
                .font(.custom("Chalkboard SE", size: 18))
                .padding(.leading, 16)
            Text(task.taskDescription)
                .font(.custom("Chalkboard SE", size: 16))
                .padding(.horizontal, 16)

            Text("Time:")
                .font(.custom("Chalkboard SE", size: 18))
                .padding(.leading, 16)
            Text(task.time, style: .time)
                .font(.custom("Chalkboard SE", size: 16))
                .padding(.horizontal, 16)

            if !task.sharedWith.isEmpty {
                Text("Shared With:")
                    .font(.custom("Chalkboard SE", size: 18))
                    .padding(.leading, 16)
                Text(task.sharedWith.joined(separator: ", "))
                    .font(.custom("Chalkboard SE", size: 16))
                    .padding(.horizontal, 16)
            }

            Text("Status:")
                .font(.custom("Chalkboard SE", size: 18))
                .padding(.leading, 16)
            Text(task.isCompleted ? "Completed" : "Not Completed")
                .font(.custom("Chalkboard SE", size: 16))
                .padding(.horizontal, 16)
                .foregroundColor(task.isCompleted ? .green : .red)

            Spacer()

            // Drawing area
            ZStack {
                Rectangle()
                    .fill(Color(white: 0.95))
                    .cornerRadius(10)

                // Draw the user's gesture path
                if !drawingPoints.isEmpty {
                    Path { path in
                        path.addLines(drawingPoints)
                    }
                    .stroke(Color.green, lineWidth: 2)
                }

                // Show the prompt when not drawing
                if drawingPoints.isEmpty {
                    Text("Draw a checkmark here to mark as completed")
                        .font(.custom("Chalkboard SE", size: 16))
                        .foregroundColor(.gray)
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
        }
        .navigationBarTitle("Task Details", displayMode: .inline)
    }

    private func markTaskCompleted() {
        task.isCompleted = true
        // Update the task in the model context
        modelContext.insert(task)
    }

    private func isCheckmarkShape(points: [CGPoint]) -> Bool {
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

