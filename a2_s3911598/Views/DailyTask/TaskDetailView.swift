import SwiftUI
import SwiftData

struct TaskDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var task: Task
    @State private var drawingPoints: [CGPoint] = []
    @State private var isLongPressActive = false
    private var injectedModelContext: ModelContext?

    init(task: Task,modelContext: ModelContext? = nil ) {
        _task = State(initialValue: task)
        self.injectedModelContext = modelContext
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Task details
            Text("TiTle:")
                .font(.custom("Chalkboard SE", size: 18))
                .padding(.leading, 16)
                .padding(.top, 0)
            Text(task.title)
                .font(.custom("Chalkboard SE", size: 16))
                .padding([.leading], 16)

            Text("Description:")
                .font(.custom("Chalkboard SE", size: 18))
                .padding(.leading, 16)
            Text(task.taskDescription)
                .font(.custom("Chalkboard SE", size: 16))
                .padding(.horizontal, 16)
            
            if let imageData = task.imageData, let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 100)
                    .clipped()
                    .cornerRadius(10)
                    .padding(.horizontal)
            }


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


            // Drawing area
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

                // Show the prompt when not drawing
//                if drawingPoints.isEmpty {
//                    Text("Draw a checkmark here to mark as completed")
//                        .font(.custom("Chalkboard SE", size: 16))
//                        .foregroundColor(.gray)
//                }
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

    func markTaskCompleted() {
        task.isCompleted = true
        let context = injectedModelContext ?? modelContext
        // Update the task in the model context
        context.insert(task)
    }

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

