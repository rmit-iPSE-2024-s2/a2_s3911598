import SwiftUI
import SwiftData

struct DailyTaskView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Task.time, order: .forward) public var tasks: [Task]
    private var injectedModelContext: ModelContext?

    @State private var showingCreateTaskView = false
    
    init(modelContext: ModelContext? = nil) {
        self.injectedModelContext = modelContext
    }

    var body: some View {
        let currentTasks = tasks
        VStack(alignment: .leading) {
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

    func getMyTasks(from tasks: [Task]) -> [Task] {
        tasks.filter { $0.sharedWith.isEmpty }
    }
    
    func getSharedTasks(from tasks: [Task]) -> [Task] {
        tasks.filter { !$0.sharedWith.isEmpty }
    }
    func deleteTask(_ task: Task) {
        let context = injectedModelContext ?? modelContext
        context.delete(task)
    }
}


