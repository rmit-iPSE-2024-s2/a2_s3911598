import SwiftUI
import Charts
import SwiftData

struct MoodView: View {
    @State private var showCalendar = false
    @State private var showMoodTracking = false
    @State private var isActive = false
    
    // SwiftData 相关
    @Environment(\.modelContext) private var modelContext
    @StateObject private var repository: MoodRepository  // 使用 @StateObject 以支持修改
    
    // 存储从数据库中获取的情绪数据
    @State private var moodData: [Mood] = []
    
    // 初始化
    init(context: ModelContext) {
        _repository = StateObject(wrappedValue: MoodRepository(context: context))
    }
    
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
                                CalendarView(context: modelContext)  // 传递你当前的 MoodRepository 到 CalendarView 中
                            
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
                        
                        Spacer()
                        Button(action: {
                            showMoodTracking = true
                        }) {
                            Text("Go record")
                                .font(Font.custom("Chalkboard SE", size: 16))
                        }
                        .sheet(isPresented: $showMoodTracking) {
                            MoodTrackingView(isActive: $showMoodTracking, repository: repository)
                        }
                    }
                    .padding(.vertical)
                }
                
                // 情绪分布图表
                cardView {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("🌼 Recent mood distribution")
                                .font(Font.custom("Chalkboard SE", size: 20))
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        // 使用数据库中获取的情绪数据绘制图表
                        Chart {
                            ForEach(moodData) { mood in
                                BarMark(
                                    x: .value("Date", mood.date),
                                    y: .value("Mood Level", mood.moodLevel)
                                )
                            }
                        }
                        .frame(height: 200)
                        .padding()
                    }
                    .padding(.vertical)
                }
                
                Spacer()
            }
        }
        .background(Color("AppBackground").edgesIgnoringSafeArea(.all))
        .onAppear {
            moodData = repository.fetchAllMoods()  // 视图加载时更新情绪数据
        }
    }
    
    // Helper: 获取情绪描述
    func getMoodDescription(for level: Int) -> String {
        switch level {
        case 1: return "Very Unpleasant"
        case 2: return "Unpleasant"
        case 3: return "Neutral"
        case 4: return "Pleasant"
        case 5: return "Very Pleasant"
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
