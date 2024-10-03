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

            // 月历网格视图
            let days = generateDaysInMonth(for: currentMonth)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(days, id: \.self) { date in
                    VStack {
                        Text(dayString(from: date))
                            .font(.headline)
                        
                        // 获取该日期的最后一个情绪记录
                        if let mood = moodForDate(date) {
                            moodIcon(for: mood.moodLevel)
                        } else {
                            Circle().fill(Color.gray.opacity(0.3)).frame(width: 30, height: 30)
                        }
                    }
                    .onTapGesture {
                        selectedDate = date
                    }
                    .padding()
                }
            }
            
            // 显示选中的日期记录
            if let selectedDate = selectedDate {
                showMoodsForDate(selectedDate)
            } else {
                Text("Select a date to view moods")
                    .padding()
            }
        }
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
    func moodIcon(for moodLevel: Int) -> some View {
        let iconName: String
        switch moodLevel {
        case 1: iconName = "face.dashed"
        case 2: iconName = "face.smiling"
        case 3: iconName = "face.neutral"
        case 4: iconName = "face.smiling.fill"
        case 5: iconName = "face.sunglasses"
        default: iconName = "questionmark.circle"
        }
        return Image(systemName: iconName)
            .resizable()
            .frame(width: 30, height: 30)
            .foregroundColor(.blue)
    }

    // 生成指定月份的日期
    func generateDaysInMonth(for date: Date) -> [Date] {
        guard let range = Calendar.current.range(of: .day, in: .month, for: date) else {
            return []
        }

        let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: date))!
        return range.compactMap { day in
            Calendar.current.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
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

//struct CalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarView(context: .constant([]))  // 传递一个空的绑定数组
//    }
//}


