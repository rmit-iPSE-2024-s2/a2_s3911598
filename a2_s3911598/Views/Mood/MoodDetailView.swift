//
//  MoodDetailView.swift
//  a2_s3911598
//
//  Created by Lea Wang on 3/10/2024.
//

import SwiftUI

struct MoodDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var moodText: String = ""
    @Binding var isActive: Bool
    @Binding var selectedMood: String
    let currentDate = Date()

    var body: some View {
        VStack(alignment: .center) {
            // 显示当前日期
            Text(currentDate, formatter: dateFormatter)
                .font(Font.custom("Chalkboard SE", size: 18))
                .padding(.top, 20)

            // 显示用户选择的情绪图片
            Image(imageName(for: selectedMood))
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.top, 20)

            // 显示选择的情绪标签
            Text("“ \(selectedMood) ”")
                .font(Font.custom("Chalkboard SE", size: 30))
                .fontWeight(.bold)
                .padding(.vertical, 10)

            // 显示情绪描述文本
            Text(displayText(for: selectedMood))
                .font(Font.custom("Chalkboard SE", size: 18))
                .padding(.bottom, 10)
                .padding(.horizontal)
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)

            // 输入情绪备注
            TextField("Write down your mood", text: $moodText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(Font.custom("Chalkboard SE", size: 16))
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)

            Spacer()

            // 完成按钮
            Button(action: {
                self.isActive = false  // 关闭视图
            }) {
                HStack {
                    Spacer()
                    Text("Done")
                        .font(Font.custom("Chalkboard SE", size: 20))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal)
        .background(Color(UIColor.systemGray5).edgesIgnoringSafeArea(.all))
    }

    // Helper 函数：根据情绪标签返回图片名称
    func imageName(for mood: String) -> String {
        switch mood {
        case "Slightly pleasant":
            return "slightlyUnpleasant"
        case "Pleasant":
            return "happy"
        case "Very pleasant":
            return "very happy"
        case "Very unpleasant":
            return "VeryUnpleasant"
        case "Unpleasant":
            return "unpleasant"
        default:
            return "normal"
        }
    }

    // Helper 函数：根据情绪标签返回描述文本
    func displayText(for mood: String) -> String {
        switch mood.lowercased() {  // 将 mood 转换为小写
        case "slightly pleasant":
            return "Keep calm and carry on."
        case "pleasant", "very pleasant":
            return "Good to know you're feeling great."
        case "very unpleasant":
            return "I sometimes feel very bad too, I understand how oppressively heavy that can feel."
        case "slightly unpleasant":
            return "I have been just ok at times as well."
        default:
            return "Good to know you're feeling \(mood.lowercased())!"
        }
    }

    
    func saveMood() {
           let newMood = Mood(date: currentDate, moodLevel: selectedMood, notes: moodText)
           modelContext.insert(newMood)
           print(newMood)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
//        context.save()
       }
}

