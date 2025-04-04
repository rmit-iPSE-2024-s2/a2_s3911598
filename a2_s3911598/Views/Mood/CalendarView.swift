import SwiftUI
import SwiftData

/// The `CalendarView` struct provides an interface for displaying a calendar and viewing mood records by date.
///
/// This view allows users to navigate through months, select specific dates, and view any mood records associated with those dates.
struct CalendarView: View {
    
    /// The environment's model context used for managing mood data.
    @Environment(\.modelContext) private var modelContext
    
    /// The currently selected date.
    @State private var selectedDate: Date? = nil
    
    /// A query that fetches all mood records.
    @Query private var allMoods: [Mood]
    
    // Current month
    @State var currentMonth: Date = Date()
    var injectedMoods: [Mood]?
    init(injectedMoods: [Mood]? = nil) {
        self.injectedMoods = injectedMoods
    }
    
    
    var body: some View {
        VStack {
            
            // Month switcher
            HStack {
                Button(action: {
                    if let previous = previousMonth(from: currentMonth) {
                        currentMonth = previous
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .shadow(radius: 2)
                }

                Spacer()
                
                Text(monthYearString(from: currentMonth))
                    .font(.title)
                    .bold()
                    .transition(.opacity)
                
                Spacer()
                
                Button(action: {
                    if let next = nextMonth(from: currentMonth) {
                        currentMonth = next
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .shadow(radius: 2)
                }
            }
            .padding()


            // Calendar wrapped in a card with a light gray background and rounded corners
            VStack {
                // Display weekdays
                HStack {
                    ForEach(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], id: \.self) { day in
                        Text(day)
                            .frame(maxWidth: .infinity)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom, 5)

                // Calendar
                let days = generateDaysInMonth(for: currentMonth)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                    ForEach(days, id: \.self) { date in
                        VStack {
                            if let date = date {
                                Text(dayString(from: date))
                                    .font(.subheadline)  // Use smaller font size
                                    .foregroundColor(.black)
                                
                                // Get the last mood record for the date
                                if let mood = moodForDate(date) {
                                    moodIcon(for: mood.moodLevel)
                                } else {
                                    Circle().fill(Color.gray.opacity(0.3)).frame(width: 30, height: 30)
                                }
                            } else {
                                // Empty day slots for padding
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
            .background(Color.purple.opacity(0.1))   // Light gray background card
            .cornerRadius(15)
            .padding()

            // Display selected date's mood records
            VStack {
                if let selectedDate = selectedDate {
                    showMoodsForDate(selectedDate)
                } else {
                    Text("Select a date to view moods")
                        .padding()
                }
            }
            .frame(maxWidth: .infinity)  // Expand container width
            .background(Color(UIColor.systemBackground))
            .cornerRadius(15)
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
    }

    // Display mood records for the selected date
    @ViewBuilder
    func showMoodsForDate(_ date: Date) -> some View {
        VStack {
            Text("Moods \(dateFormatter.string(from: date))")
                .font(.headline)
                .padding(.top)
            
            if let mood = moodForDate(date) {
                Text("Mood Level: \(mood.moodLevel)")
                // Only show the notes if they are not empty
                if !mood.notes.isEmpty {
                    Text("Notes: \(mood.notes)")
                }
            } else {
                Text("No records for this date.")
            }
        }
        .padding()
    }

    // Get mood record for a given date
    func moodForDate(_ date: Date) -> Mood? {
        let moods = injectedMoods ?? allMoods
        return moods.last(where: { Calendar.current.isDate($0.date, inSameDayAs: date) })
    }
    
    // Display mood icon
    
    /// - Parameter moodLevel: The mood level.
    /// - Returns: A view containing the appropriate icon for the mood level.
    func moodIcon(for moodLevel: String) -> some View {
        let imageName: String
        switch moodLevel {
        case "Very Unpleasant": imageName = "VeryUnpleasant"
        case "Slightly UnPleasant":imageName = "SlightlyUnPleasant"
        case "Unpleasant": imageName = "Unpleasant"
        case "Neutral": imageName = "Normal"
        case "Slightly Pleasant": imageName = "SlightlyPleasant"
        case "Pleasant": imageName = "Happy"
        case "Very Pleasant": imageName = "VeryHappy"
        default: imageName = "questionmark.circle"
        }
        return Image(imageName)  // Using images from assets
            .resizable()
            .frame(width: 30, height: 30)
    }

    // Generate days in the current month
    func generateDaysInMonth(for date: Date) -> [Date?] {
        guard let range = Calendar.current.range(of: .day, in: .month, for: date),
              let firstOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: date)) else {
            return []
        }
        
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Set Monday as the first day of the week
        
        let firstDayOfWeek = calendar.component(.weekday, from: firstOfMonth) - calendar.firstWeekday
        let daysBefore = Array(repeating: Date?.none, count: firstDayOfWeek < 0 ? 0 : firstDayOfWeek)
        let daysInMonth = range.compactMap { day -> Date? in
            return calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth)
        }

        return daysBefore + daysInMonth
    }

    // Get the string for the day
    func dayString(from date: Date) -> String {
        let components = Calendar.current.dateComponents([.day], from: date)
        return String(components.day ?? 0)
    }
    
    // Get the string for the month and year
    func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    // Switch to the previous month
    func previousMonth(from date: Date) -> Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: date)
    }

    // Switch to the next month
    func nextMonth(from date: Date) -> Date? {
        return Calendar.current.date(byAdding: .month, value: 1, to: date)
    }
}
