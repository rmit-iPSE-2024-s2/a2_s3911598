import SwiftUI
import Charts
import SwiftData

struct MoodView: View {
    @State private var showCalendar = false
    @State private var showMoodTracking = false
    @State private var isActive = false
    @State private var selectedFriends: [Friend] = []
    @State private var showFriendsPicker = false
   
   
    
    // SwiftData related
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Mood.date, order: .reverse) private var moodData: [Mood]
    @Query private var friends: [Friend]

    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Moods")
                    .font(.custom("Chalkboard SE", size: 24))
                    .padding([.leading, .top], 16)
                
                // Recent mood record section
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
                        
                        // Display recent mood data
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
                
                // “How do you feel today” card
                cardView {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("How do you feel today?")
                                .font(Font.custom("Chalkboard SE", size: 20))
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        // Go record button
                        Button(action: {
                            showMoodTracking = true
                        }) {
                            Text("Go record")
                                .font(Font.custom("Chalkboard SE", size: 18))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("primaryMauve"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                        .sheet(isPresented: $showMoodTracking) {
                            MoodTrackingView(isActive: $showMoodTracking)
                        }
                    }
                    .padding(.vertical)
                }
                
                // Display today's mood record
                if let todayMood = moodForToday() {
                    cardView {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Today's Mood Record")
                                .font(Font.custom("Chalkboard SE", size: 20))
                            Text("Time: \(timeFormatter.string(from: todayMood.date))")
                                .font(Font.custom("Chalkboard SE", size: 18))
                            Text("Mood: \(getMoodDescription(for: todayMood.moodLevel))")
                                .font(Font.custom("Chalkboard SE", size: 18))
                            
                            // "Share this with..." button
                            Button(action: {
                                showFriendsPicker = true
                            }) {
                                Text("Share this with...")
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
                        .padding()
                    }
                    .padding(.bottom)
                } else {
                    // If no mood record for today, show a placeholder message
                    Text("No mood recorded for today yet.")
                        .font(Font.custom("Chalkboard SE", size: 18))
                        .foregroundColor(.gray)
                        .padding()
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $showFriendsPicker) {
            FriendsPickerView(friends: friends, selectedFriends: $selectedFriends)
        }
        .background(Color("AppBackground").edgesIgnoringSafeArea(.all))
    }
    
    // Get today's mood record
    func moodForToday() -> Mood? {
        return moodData.first(where: { Calendar.current.isDateInToday($0.date) })
    }
    
    // Time formatter
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    // Helper: Get mood description
    func getMoodDescription(for mood: String) -> String {
        switch mood {
        case "Very Unpleasant": return "Very Unpleasant"
        case "Unpleasant": return "Unpleasant"
        case "Neutral": return "Neutral"
        case "Pleasant": return "Pleasant"
        case "Slightly Pleasant": return "Slightly Pleasant"
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
