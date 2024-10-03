//
//  DailyTaskView.swift
//  a1_s3911598
//
//  Created by Lea Wang on 27/8/2024.
//

import SwiftUI
import SwiftData

struct DailyTaskView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var tasks: [Task] = []
    @State private var showingCreateTaskView = false
    
    var sharedTasksBinding: [Binding<Task>] {
        $tasks.enumerated()
            .compactMap { index, taskBinding in
                if tasks[index].sharedWith.isEmpty == false {
                    return taskBinding
                } else {
                    return nil
                }
            }
    }

    var myTasksBinding: [Binding<Task>] {
        $tasks.enumerated()
            .compactMap { index, taskBinding in
                if tasks[index].sharedWith.isEmpty {
                    return taskBinding
                } else {
                    return nil
                }
            }
    }

    var body: some View {
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
                let sharedTasks = tasks.filter { !$0.sharedWith.isEmpty }
                let myTasks = tasks.filter { $0.sharedWith.isEmpty }
                Section(header: Text("Shared Tasks").font(.custom("Chalkboard SE", size: 20)).padding(.top, -10)) {
                    ForEach(sharedTasksBinding, id: \.id) { $task in
                        NavigationLink(destination: TaskDetailView(task: $task)) {
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
                    .onDelete { offsets in
                        deleteTask(at: offsets, from: tasks)
                    }
                }

                Section(header: Text("My Daily Tasks").font(.custom("Chalkboard SE", size: 20)).padding(.top, -10)) {
                    ForEach(myTasksBinding, id: \.id) { $task in
                        NavigationLink(destination: TaskDetailView(task: $task)) {
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
                    .onDelete { offsets in
                        deleteTask(at: offsets, from: tasks)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .sheet(isPresented: $showingCreateTaskView) {
                CreateTaskView(isPresented: $showingCreateTaskView, tasks: $tasks)
            }
            .onAppear(perform: loadTasks)
        }
    }

    private func loadTasks() {
        tasks = TaskRepository().fetchAllTasks(context: modelContext)
    }

    private func deleteTask(at offsets: IndexSet, from filteredTasks: [Task]) {
        for offset in offsets {
            let task = filteredTasks[offset]
            TaskRepository().deleteTask(context: modelContext, task: task)
        }
        loadTasks()
    }
    
    private func deleteTask(_ task: Task) {
        TaskRepository().deleteTask(context: modelContext, task: task)
        loadTasks()
    }


}



struct CreateTaskView: View {
    @Binding var isPresented: Bool
    @Binding var tasks: [Task]
    @State private var title = ""
    @State private var description = ""
    @State private var time = Date()

    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Create a New Task")
                    .font(.custom("Chalkboard SE", size: 24))
                    .padding([.top, .leading], 16)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Task Title")
                        .font(.custom("Chalkboard SE", size: 18))
                        .padding(.leading, 10)

                    TextField("Enter title", text: $title)
                        .font(.custom("Chalkboard SE", size: 18))
                        .padding()
                        .background(Color(white: 0.9))
                        .cornerRadius(10)
                        .padding(.horizontal)

                    Text("Task Description")
                        .font(.custom("Chalkboard SE", size: 18))
                        .padding(.leading, 10)

                    TextField("Enter description", text: $description)
                        .font(.custom("Chalkboard SE", size: 18))
                        .padding()
                        .background(Color(white: 0.9))
                        .cornerRadius(10)
                        .padding(.horizontal)

                    Text("Time")
                        .font(.custom("Chalkboard SE", size: 18))
                        .padding(.leading, 10)

                    DatePicker("Select Time", selection: $time, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .font(.custom("Chalkboard SE", size: 18))
                        .padding()
                        .background(Color(white: 0.9))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    Button(action: {
                    }) {
                        Text("Doing this with...")
                            .font(.custom("Chalkboard SE", size: 18))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("primaryMauve"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }.padding(.top, 16)
                }
                .padding([.leading, .trailing], 8)
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .font(.custom("Chalkboard SE", size: 18))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        TaskRepository().addTask(context: modelContext, title: title, description: description, time: time, sharedWith: [])
                        loadTasks()
                        isPresented = false
                    }
                    .font(.custom("Chalkboard SE", size: 18))
                }
            }
        }
    }

    private func loadTasks() {
        tasks = TaskRepository().fetchAllTasks(context: modelContext)
    }
}


struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .foregroundColor(.white)
                    .imageScale(.large)
                configuration.label
            }
        }
    }
}

//struct DailyTaskView_Previews: PreviewProvider {
//    static var previews: some View {
//        DailyTaskView()
//    }
//}
