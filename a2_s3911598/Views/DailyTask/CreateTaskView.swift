//
//  CreateTaskView.swift
//  a2_s3911598
//
//  Created by lea.Wang on 7/10/2024.
//

import SwiftUI
import SwiftData
struct CreateTaskView: View {
    @Binding var isPresented: Bool
    
    @State var title = ""
    @State var description = ""
    @State var time = Date()
    @State var showImagePicker = false
    @State var selectedImage: UIImage?
    @State var selectedFriends: [Friend] = []
    @State var showFriendsPicker = false
    @StateObject private var activityModel = ActivityModel()
    @Environment(\.modelContext) private var modelContext
    private var injectedModelContext: ModelContext?
    @State private var showError = false
    @Query private var friends: [Friend]
    
    init(isPresented: Binding<Bool>, modelContext: ModelContext? = nil) {
        _isPresented = isPresented
        self.injectedModelContext = modelContext
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
    
    func saveTask() {
        let context = injectedModelContext ?? modelContext
        
        let newTask = Task(
            title: title,
            taskDescription: description,
            time: time,
            sharedWith: selectedFriends.map { $0.name },
            imageData: selectedImage?.jpegData(compressionQuality: 0.8)
        )
        context.insert(newTask)

        let taskCodable = TaskCodable(
            title: newTask.title,
            taskDescription: newTask.taskDescription,
            time: newTask.time,
            sharedWith: newTask.sharedWith,
            isCompleted: newTask.isCompleted,
            imageData: newTask.imageData
        )

        if let sharedDefaults = UserDefaults(suiteName: "group.com.a2-s3911598.a2-s3911598") {
            if let taskData = try? JSONEncoder().encode(taskCodable) {
                sharedDefaults.set(taskData, forKey: "currentTask")
            }
        }
    }

}


