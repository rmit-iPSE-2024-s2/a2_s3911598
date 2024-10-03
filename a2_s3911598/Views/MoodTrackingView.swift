import SwiftUI

struct MoodTrackingView: View {
    @Binding var isActive: Bool
    let repository: MoodRepository  // 用于保存情绪的仓库
    
    @State private var moodValue: Double = 0.5
    @State private var selectedMoodLabel = "Neutral"
    @State private var showingMoodDetailView = false
    
    // 情绪颜色渐变
    let moodColors = [
        Color(red: 0.68, green: 0.77, blue: 0.89),
        Color(red: 0.74, green: 0.83, blue: 0.91),
        Color(red: 0.79, green: 0.88, blue: 0.94),
        Color(red: 0.93, green: 0.88, blue: 0.68),
        Color(red: 0.98, green: 0.86, blue: 0.53),
        Color(red: 0.99, green: 0.80, blue: 0.67),
        Color(red: 0.99, green: 0.70, blue: 0.63)
    ]
    
    // 情绪描述标签
    let moodLabels = [
        "Very unpleasant",
        "Unpleasant",
        "Slightly unpleasant",
        "Neutral",
        "Slightly pleasant",
        "Pleasant",
        "Very pleasant"
    ]
    
    var body: some View {
        ZStack {
            // 基于 moodValue 设置背景渐变颜色
            moodColors[Int(moodValue * Double(moodColors.count - 1))]
                .edgesIgnoringSafeArea(.all)
                .animation(.easeInOut, value: moodValue)
            
            VStack(spacing: 20) {
                Spacer()
                
                // 显示不同心情的图片
                Image("image")  // 替换为相关图片名称
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                
                ZStack {
                    Slider(value: $moodValue)
                        .padding(.horizontal)
                    
                    // 显示根据滑块变化的情绪标签
                    Text(moodLabels[Int(moodValue * Double(moodLabels.count - 1))])
                        .font(Font.custom("Chalkboard SE", size: 20))
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .offset(x: (CGFloat(moodValue) - 0.5) * 300, y: -50)  // 调整标签位置
                        .animation(.easeInOut, value: moodValue)
                }
                
                HStack {
                    Text("Very unpleasant")
                        .font(Font.custom("Chalkboard SE", size: 14))
                        .foregroundColor(.gray)
                    Spacer()
                    Text("Very pleasant")
                        .font(Font.custom("Chalkboard SE", size: 14))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // 保存情绪并打开详情页
                Button(action: {
                    self.selectedMoodLabel = moodLabels[Int(moodValue * Double(moodLabels.count - 1))]
                    
                    // 调用 repository.addMood() 保存情绪记录
                    repository.addMood(
                        moodLevel: Int(moodValue * 5),  // 根据滑块的值保存情绪等级
                        notes: "User is feeling \(selectedMoodLabel)",  // 你可以传递情绪说明作为备注
                        sharedWith: []  // 如果有需要，可以传递共享的人员信息
                    )
                    
                    self.showingMoodDetailView = true
                }) {
                    HStack {
                        Spacer()
                        Text("Next")
                            .font(Font.custom("Chalkboard SE", size: 20))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 50)
        }
        .sheet(isPresented: $showingMoodDetailView) {
            MoodDetailView(isActive: $isActive, selectedMood: $selectedMoodLabel)
        }
    }
}
