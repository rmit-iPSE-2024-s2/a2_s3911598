//
//  TaskCardView.swift
//  a2_s3911598
//
//  Created by lea.Wang on 3/10/2024.
//

import SwiftUI


/// The `TaskCard` struct displays a task's title, description, time, and shared participants in a stylized card.
///
/// This view represents a single task as a card, showing relevant task information. It uses different background colors depending on whether the task is completed.
struct TaskCard: View {
    /// The task to be displayed.
    var task: Task

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.title)
                    .font(.custom("Chalkboard SE", size: 18))
                    .foregroundColor(.white)
                Text(task.taskDescription)
                    .font(.custom("Chalkboard SE", size: 16))
                    .foregroundColor(.white.opacity(0.7))
                if !task.sharedWith.isEmpty {
                    Text("Doing with: \(task.sharedWith.joined(separator: ", "))")
                        .font(.custom("Chalkboard SE", size: 14))
                        .foregroundColor(.white.opacity(0.5))
                }
            }
            Spacer()
            Text(task.time, style: .time)
                .foregroundColor(.white)
                .font(.custom("Chalkboard SE", size: 16))
        }
        .padding()
        .background(task.isCompleted ? Color("secondaryLilac") : Color("primaryMauve"))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

