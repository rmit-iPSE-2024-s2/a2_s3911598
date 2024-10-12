//
//  CreateTaskView.swift
//  a2_s3911598
//
//  Created by lea.Wang on 7/10/2024.
//

import SwiftUI
import SwiftData
import WidgetKit

/// The `CreateTaskView` struct allows users to create a new task with a title, description, time, image, and team members.
///
/// This view provides input fields for task details, including options to upload an image, select friends to collaborate with, and fetch a random task.
struct CreateTaskView: View {
    
    /// Controls whether the view is presented.
    @Binding var isPresented: Bool
    
    /// The title of the task.
    @State var title = ""
    
    /// The description of the task.
    @State var description = ""
    
    /// The time selected for the task.
    @State var time = Date()
    
    /// Controls whether the image picker is shown.
    @State var showImagePicker = false
    
    /// The image selected for the task.
    @State var selectedImage: UIImage?
    
    /// The friends selected to collaborate on the task.
    @State var selectedFriends: [Friend] = []
    
    /// Controls whether the friends picker is shown.
    @State var showFriendsPicker = false
    
    /// The model object responsible for fetching random activities.
    @StateObject private var activityModel = ActivityModel()
    
    /// The environment's model context for managing task data.
    @Environment(\.modelContext) private var modelContext
    
    /// Optional injected model context (for testing or dependency injection).
    private var injectedModelContext: ModelContext?
    
    /// Optional injected `UserDefaults` for storing tasks.
    private var injectUserDefaults: UserDefaults?
    
    /// Tracks whether to show an error message if the title is empty.
    @State private var showError = false
    
    /// A query that fetches a list of friends.
    @Query private var friends: [Friend]
    
    /// A query that fetches tasks sorted by time.
    @Query(sort: \Task.time, order: .forward) public var tasks: [Task]
    
       /// Initializes the `CreateTaskView` with optional parameters for dependency injection.
       ///
       /// - Parameters:
       ///   - isPresented: A binding to control whether the view is presented.
       ///   - title: The initial task title (default: empty).
       ///   - description: The initial task description (default: empty).
       ///   - time: The initial task time (default: current date).
       ///   - showImagePicker: Whether to show the image picker (default: false).
       ///   - selectedImage: The initial selected image (default: nil).
       ///   - selectedFriends: The initial selected friends (default: empty array).
       ///   - showFriendsPicker: Whether to show the friends picker (default: false).
       ///   - modelContext: An optional model context for managing data (default: nil).
       ///   - userDefaults: Optional `UserDefaults` for saving tasks (default: nil).
       init(
        isPresented: Binding<Bool>,
        title: String = "",
        description: String = "",
        time: Date = Date(),
        showImagePicker: Bool = false,
        selectedImage: UIImage? = nil,
        selectedFriends: [Friend] = [],
        showFriendsPicker: Bool = false,
        modelContext: ModelContext? = nil,
        userDefaults:UserDefaults?=nil
    ) {
        _isPresented = isPresented
        _title = State(initialValue: title)
        _description = State(initialValue: description)
        _time = State(initialValue: time)
        _showImagePicker = State(initialValue: showImagePicker)
        _selectedImage = State(initialValue: selectedImage)
        _selectedFriends = State(initialValue: selectedFriends)
        _showFriendsPicker = State(initialValue: showFriendsPicker)
        self.injectedModelContext = modelContext
        self.injectUserDefaults = userDefaults
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Create a New Task")
                    .font(.custom("Chalkboard SE", size: 24))
                    .padding([.leading], 16)
                
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
                    
                    if showError && title.isEmpty {
                        Text("Title is required.")
                            .foregroundColor(.red)
                            .font(.custom("Chalkboard SE", size: 14))
                            .padding(.leading, 10)
                    }
                    
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
                        .padding()
                        .background(Color(white: 0.9))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    Button(action: {
                        showImagePicker = true
                    }) {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 150)
                                .clipped()
                                .cornerRadius(10)
                                .padding(.horizontal)
                        } else {
                            Rectangle()
                                .fill(Color(white: 0.9))
                                .frame(height: 150)
                                .overlay(
                                    Text("Add photos")
                                        .font(.custom("Chalkboard SE", size: 18))
                                        .foregroundColor(.gray)
                                )
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePickerViewModel(selectedImage: $selectedImage)
                    }
                    
                    HStack {
                         Button(action: {
                             fetchRandomTask()
                         }) {
                             Text("Roll a Random Task!")
                                 .font(Font.custom("Chalkboard SE", size: 18))
                                 .frame(maxWidth: .infinity)
                                 .padding()
                                 .background(Color("primaryMauve"))
                                 .foregroundColor(.white)
                                 .cornerRadius(10)
                         }

                         Button(action: {
                             showFriendsPicker = true
                         }) {
                             Text("Team Up with Someone")
                                 .font(Font.custom("Chalkboard SE", size: 18))
                                 .frame(maxWidth: .infinity)
                                 .padding()
                                 .background(Color("primaryMauve"))
                                 .foregroundColor(.white)
                                 .cornerRadius(10)
                         }
                     }
                     .padding(.horizontal)
                     .padding(.top, 16)
                    
                }
                .padding([.leading, .trailing], 8)
                .onChange(of: activityModel.result) {
                    if let activityResult = activityModel.result {
                        title = activityResult.type.capitalized
                        description = activityResult.activity
                    }
                }

                
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
                        if title.isEmpty {
                            showError = true
                        } else {
                            saveTask()
                            isPresented = false
                        }
                    }
                    .font(.custom("Chalkboard SE", size: 18))
                }
            }
            .sheet(isPresented: $showFriendsPicker) {
                FriendsPickerView(
                    friends: friends,
                    selectedFriends: $selectedFriends,
                    isPresented: $showFriendsPicker
                )
            }

        }
    }
    
    func fetchRandomTask() {
        activityModel.fetchActivity()
    }
    
    /// Saves the created task to the model context and stores it in shared `UserDefaults` for widget updates.
    func saveTask() {
        let context = injectedModelContext ?? modelContext
        
        let newTask = Task(
            title: title,
            taskDescription: description,
            time: time,
            sharedWith: selectedFriends.map { $0.name },
            imageData: selectedImage?.jpegData(compressionQuality: 0.8)
        )
        if newTask.title.isEmpty {
            return
        }
        context.insert(newTask)

        let allTasks: [Task]
        if let injectedContext = injectedModelContext {
            allTasks = try! injectedContext.fetch(FetchDescriptor<Task>())
        } else {
            allTasks = tasks
        }

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
        let defaults = injectUserDefaults ?? UserDefaults(suiteName: "group.com.a2-s3911598.a2-s3911598")

        if let taskData = try? JSONEncoder().encode(taskCodables) {
            defaults?.set(taskData, forKey: "allTasks")
            WidgetCenter.shared.reloadTimelines(ofKind: "CurrentTaskWidget")
        }
    }

}


