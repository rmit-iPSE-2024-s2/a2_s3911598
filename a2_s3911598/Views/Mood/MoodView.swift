import SwiftUI
import Charts
import SwiftData

struct MoodView: View {
    @State private var showCalendar = false
    @State private var showMoodTracking = false
    @State private var isActive = false
    
    // SwiftData 相关
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Mood.date, order: .reverse) private var moodData: [Mood]

    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Moods")
                    .font(.custom("Chalkboard SE", size: 24))
                    .padding([.leading, .top], 16)
                
                // 最近情绪记录部分
                cardView {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                            Text("My daily mood record")
                                .font(Font.custom("Chalkboard SE", size: 20))
                            Spacer()
                            Button(action: {
                                showCalendar = true
                            }) {
                                HStack {
                                    Image(systemName: "eyes")
                                    Text("View all")
                                        .font(Font.custom("Chalkboard SE", size: 16))
                                }
                            }
                            .sheet(isPresented: $showCalendar) {
                                CalendarView()
                            
                            }
                        }
                        .padding(.horizontal)
                        
                        // 显示最近的情绪数据
                        if let recentMood = moodData.last {
                            HStack(alignment: .top) {
                                Text("Recent")
                                    .font(Font.custom("Chalkboard SE", size: 16))
                                    .foregroundColor(.gray)
                                Text(dateFormatter.string(from: recentMood.date))
                                    .font(Font.custom("Chalkboard SE", size: 14))
                                Text(getMoodDescription(for: recentMood.moodLevel))
                                    .font(Font.custom("Chalkboard SE", size: 20))
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding(.vertical)
                }
                
                // “How do you feel today” 卡片
                cardView {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("How do you feel today?")
                                .font(Font.custom("Chalkboard SE", size: 20))
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        // Go record 按钮
                        Button(action: {
                            showMoodTracking = true
                        }) {
                            Text("Go record")
                                .font(Font.custom("Chalkboard SE", size: 16))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .sheet(isPresented: $showMoodTracking) {
                            MoodTrackingView(isActive: $showMoodTracking)
                        }
                    }
                    .padding(.vertical)
                }
                
                // 显示今天的心情记录
                if let todayMood = moodForToday() {
                    cardView {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Today's Mood Record")
                                .font(Font.custom("Chalkboard SE", size: 20))
                            Text("Time: \(timeFormatter.string(from: todayMood.date))")
                                .font(Font.custom("Chalkboard SE", size: 18))
                            Text("Mood: \(getMoodDescription(for: todayMood.moodLevel))")
                                .font(Font.custom("Chalkboard SE", size: 18))
                        }
                        .padding()
                    }
                    .padding(.bottom)
                } else {
                    // 如果没有今天的心情记录，显示提示信息
                    Text("No mood recorded for today yet.")
                        .font(Font.custom("Chalkboard SE", size: 18))
                        .foregroundColor(.gray)
                        .padding()
                }
                
                Spacer()
            }
        }
        .background(Color("AppBackground").edgesIgnoringSafeArea(.all))
    }
    
    // 获取当天的心情记录
    func moodForToday() -> Mood? {
        return moodData.first(where: { Calendar.current.isDateInToday($0.date) })
    }
    
    // 时间格式化器
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    // Helper: 获取情绪描述
    func getMoodDescription(for mood: String) -> String {
        switch mood {
        case "Very Unpleasant": return "Very Unpleasant"
        case "Unpleasant": return "Unpleasant"
        case "Neutral": return "Neutral"
        case "Pleasant": return "Pleasant"
        case "Very Pleasant": return "Very Pleasant"
        default: return "Unknown"
        }
    }
    
    // Unified card view style
    @ViewBuilder
    func cardView<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(radius: 5)
                .padding(.horizontal)
            
            content()
                .padding()
        }
    }
}
