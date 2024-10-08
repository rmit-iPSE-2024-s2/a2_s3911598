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
    
    @State private var title = ""
    @State private var description = ""
    @State private var time = Date()
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var selectedFriends: [Friend] = []
    @State private var showFriendsPicker = false
    @StateObject private var activityModel = ActivityModel()
    @Environment(\.modelContext) private var modelContext
    @Query private var friends: [Friend]
    
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
                        showImagePicker = true
                    }) {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .clipped()
                                .cornerRadius(10)
                                .padding(.horizontal)
                        } else {
                            Rectangle()
                                .fill(Color(white: 0.9))
                                .frame(height: 200)
                                .overlay(
                                    Text("Tap to select an image")
                                        .foregroundColor(.gray)
                                )
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(selectedImage: $selectedImage)
                    }
                    
                    Button(action: {
                        fetchRandomTask()
                    }) {
                        Text("Generate Random Task")
                            .font(Font.custom("Chalkboard SE", size: 18))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .padding(.top, 16)
                    
                    Button(action: {
                        showFriendsPicker = true
                    }) {
                        Text("Doing this with...")
                            .font(Font.custom("Chalkboard SE", size: 18))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("primaryMauve"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
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
                        saveTask()
                        isPresented = false
                    }
                    .font(.custom("Chalkboard SE", size: 18))
                }
            }
            .sheet(isPresented: $showFriendsPicker) {
                FriendsPickerView(friends: friends, selectedFriends: $selectedFriends)
            }
        }
    }
    
    private func fetchRandomTask() {
        activityModel.fetchActivity()
    }
    
    private func saveTask() {
        let newTask = Task(
            title: title,
            taskDescription: description,
            time: time,
            sharedWith: selectedFriends.map { $0.name },
            imageData: selectedImage?.jpegData(compressionQuality: 0.8)
        )
        modelContext.insert(newTask)

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
