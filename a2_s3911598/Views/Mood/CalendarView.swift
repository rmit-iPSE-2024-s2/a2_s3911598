import SwiftUI
import SwiftData

struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var moodRepository: MoodRepository
    @State private var selectedDate: Date? = nil
    @State private var moods: [Mood] = []
    
    // 当前月份
    @State private var currentMonth: Date = Date()

    // 使用 environment 初始化 MoodRepository
    init(context: ModelContext) {
        let repository = MoodRepository(context: context)
        _moodRepository = StateObject(wrappedValue: repository)
    }
    
    var body: some View {
        VStack {
            // 返回按钮
            HStack {
                Button(action: {
                    // 返回到上一个页面的逻辑
                }) {
                    Image(systemName: "arrow.backward")
                        .foregroundColor(.black)
                        .padding()
                }
                Spacer()
            }
            
            // 月份切换器
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                }
                
                Spacer()
                
                Text(monthYearString(from: currentMonth))
                    .font(.title)
                    .bold()
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                }
            }
            .padding()

            // 日历部分包裹在卡片内，带浅灰色背景和圆角
            VStack {
                // 显示星期几
                HStack {
                    ForEach(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], id: \.self) { day in
                        Text(day)
                            .frame(maxWidth: .infinity)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom, 5)

                // 日历部分
                let days = generateDaysInMonth(for: currentMonth)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                    ForEach(days, id: \.self) { date in
                        VStack {
                            if let date = date {
                                Text(dayString(from: date))
                                    .font(.subheadline)  // 改为较小的字体
                                    .foregroundColor(.black)
                                
                                // 获取该日期的最后一个情绪记录
                                if let mood = moodForDate(date) {
                                    moodIcon(for: mood.moodLevel)
                                } else {
                                    Circle().fill(Color.gray.opacity(0.3)).frame(width: 30, height: 30)
                                }
                            } else {
                                // 用于填充空白的天数
                                Text("")
                                    .frame(width: 30, height: 30)
                                    .background(Color.clear)
                            }
                        }
                        .background(date != nil && selectedDate == date ? Color.blue.opacity(0.2) : Color.clear)
                        .cornerRadius(10)
                        .padding(5)
                        .onTapGesture {
                            if let date = date {
                                selectedDate = date
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))  // 设置浅灰色背景的卡片
            .cornerRadius(15)
            .padding()

            // 显示选中的日期记录和心情
            VStack {
                if let selectedDate = selectedDate {
                    showMoodsForDate(selectedDate)
                } else {
                    Text("Select a date to view moods")
                        .padding()
                }
            }
            .frame(maxWidth: .infinity)  // 让内容容器更大
            .background(Color(UIColor.systemBackground))
            .cornerRadius(15)
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .onAppear {
            moods = moodRepository.fetchAllMoods()
        }
    }

    // 显示指定日期的心情记录
    @ViewBuilder
    func showMoodsForDate(_ date: Date) -> some View {
        VStack {
            Text("Moods on \(dateFormatter.string(from: date))")
                .font(.headline)
                .padding(.top)
            
            if let mood = moodForDate(date) {
                Text("Mood Level: \(mood.moodLevel)")
                Text("Notes: \(mood.notes)")
                Text("Shared With: \(mood.sharedWith.joined(separator: ", "))")
            } else {
                Text("No records for this date.")
            }
        }
        .padding()
    }

    // 获取给定日期的心情记录
    func moodForDate(_ date: Date) -> Mood? {
        return moods.first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) })
    }
    
    // 显示心情图标
    func moodIcon(for moodLevel: String) -> some View {
        let iconName: String
        switch moodLevel {
        case "Very Unpleasant": iconName = "face.dashed"
        case "Unpleasant": iconName = "face.smiling"
        case "Neutral": iconName = "face.neutral"
        case "Pleasant": iconName = "face.smiling.fill"
        case "Very Pleasant": iconName = "face.sunglasses"
        default: iconName = "questionmark.circle"
        }
        return Image(systemName: iconName)
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundColor(.blue)
    }

    func generateDaysInMonth(for date: Date) -> [Date?] {
        guard let range = Calendar.current.range(of: .day, in: .month, for: date),
              let firstOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: date)) else {
            return []
        }
        
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // 将星期一设置为每周的第一天，2表示星期一
        
        let firstDayOfWeek = calendar.component(.weekday, from: firstOfMonth) - calendar.firstWeekday
        let daysBefore = Array(repeating: Date?.none, count: firstDayOfWeek < 0 ? 0 : firstDayOfWeek)
        let daysInMonth = range.compactMap { day -> Date? in
            return calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth)
        }

        return daysBefore + daysInMonth
    }


    // 获取某天的字符串
    func dayString(from date: Date) -> String {
        let components = Calendar.current.dateComponents([.day], from: date)
        return String(components.day ?? 0)
    }
    
    // 获取月份的字符串
    func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    // 切换到上一个月
    func previousMonth() {
        if let newMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) {
            currentMonth = newMonth
            moods = moodRepository.fetchAllMoods() // 更新心情数据
        }
    }
    
    // 切换到下一个月
    func nextMonth() {
        if let newMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) {
            currentMonth = newMonth
            moods = moodRepository.fetchAllMoods() // 更新心情数据
        }
    }
}
