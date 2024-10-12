import SwiftUI
import SwiftData
import WidgetKit

/// The `DailyTaskView` struct displays a list of daily tasks, categorized into shared and personal tasks.
///
/// This view allows users to view, create, and delete tasks. Tasks are divided into two sections: "Shared Tasks" and "My Daily Tasks". Each task can be deleted or selected to view more details.
struct DailyTaskView: View {

    /// The environment's model context for managing task data.
    @Environment(\.modelContext) private var modelContext

    /// A query that fetches tasks sorted by time in ascending order.
    @Query(sort: \Task.time, order: .forward) public var tasks: [Task]

    /// Optional injected model context (for testing or dependency injection).
    private var injectedModelContext: ModelContext?

    /// Controls whether the `CreateTaskView` is presented.
    @State private var showingCreateTaskView = false
    
    /// Initializes the `DailyTaskView` with an optional model context.
    ///
    /// - Parameter modelContext: An optional model context for managing task data (default: nil).
    init(modelContext: ModelContext? = nil) {
        self.injectedModelContext = modelContext
    }

    var body: some View {
        let currentTasks = tasks
        VStack(alignment: .leading) {
            // Header
            HStack {
                Text("Daily Tasks")
                    .font(.custom("Chalkboard SE", size: 24))
                    .padding([.leading, .top], 16)

                Spacer()

                Button(action: {
                    showingCreateTaskView = true
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .padding(.trailing, 16)
                }
            }

            // Task List
            List {
                let sharedTasks = getSharedTasks(from: currentTasks)
                let myTasks = getMyTasks(from: currentTasks)

                Section(header: Text("Shared Tasks").font(.custom("Chalkboard SE", size: 20)).padding(.top, -10)) {
                    ForEach(sharedTasks, id: \.id) { task in
                        NavigationLink(destination: TaskDetailView(task: task)) {
                            TaskCard(task: task)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        deleteTask(task)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    .tint(.gray)
                                }
                        }
                    }
                }

                Section(header: Text("My Daily Tasks").font(.custom("Chalkboard SE", size: 20)).padding(.top, -10)) {
                    ForEach(myTasks, id: \.id) { task in
                        NavigationLink(destination: TaskDetailView(task: task)) {
                            TaskCard(task: task)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        deleteTask(task)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    .tint(.gray)
                                }
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .sheet(isPresented: $showingCreateTaskView) {
                CreateTaskView(isPresented: $showingCreateTaskView)
            }
        }
    }

    /// Filters tasks to get only personal tasks (not shared).
    ///
    /// - Parameter tasks: The list of all tasks.
    /// - Returns: A list of tasks that are not shared with others.
    func getMyTasks(from tasks: [Task]) -> [Task] {
        tasks.filter { $0.sharedWith.isEmpty }
    }
    
    /// Filters tasks to get only shared tasks.
    ///
    /// - Parameter tasks: The list of all tasks.
    /// - Returns: A list of tasks that are shared with others.
    func getSharedTasks(from tasks: [Task]) -> [Task] {
        tasks.filter { !$0.sharedWith.isEmpty }
    }
    
    /// Deletes the specified task and updates the stored tasks in `UserDefaults`.
    ///
    /// - Parameter task: The task to be deleted.
    func deleteTask(_ task: Task) {
        let context = injectedModelContext ?? modelContext
        context.delete(task)

        let allTasks = tasks

        // Convert all tasks to TaskCodable objects for storage
        let taskCodables = allTasks.map { task in
            TaskCodable(
                title: task.title,
                taskDescription: task.taskDescription,
                time: task.time,
                sharedWith: task.sharedWith,
                isCompleted: task.isCompleted,
                imageData: task.imageData
            )
        }

        // Save all tasks to the shared UserDefaults
        let defaults = UserDefaults(suiteName: "group.com.a2-s3911598.a2-s3911598")

        if let taskData = try? JSONEncoder().encode(taskCodables) {
            defaults?.set(taskData, forKey: "allTasks")
            WidgetCenter.shared.reloadTimelines(ofKind: "CurrentTaskWidget")
        }
    }
}
