import SwiftUI
import Charts
import SwiftData

struct MoodView: View {
    @State private var showCalendar = false
    @State private var showMoodTracking = false
    @State private var isActive = false
    @State private var selectedFriends: [Friend] = []
    @State private var showFriendsPicker = false
    @State private var showMoodShareCard = false  // Show the Mood card
    
    
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
                        
                    
                    }
                    .padding(.vertical)
                }
                
                // “How do you feel today” card
                cardView {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                                            Text("How do you feel today?")
                                                .font(Font.custom("Chalkboard SE", size: 26))
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
                        
                            .padding(.top, 16)
                            .sheet(isPresented: $showMoodTracking) {
                                MoodTrackingView(isActive: $showMoodTracking)
                        }
                    }
                    .padding(.vertical, 16)
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
                            
                            // Display notes if available
                            if !todayMood.notes.isEmpty {
                                            Text("Notes: \(todayMood.notes)")
                                                .font(Font.custom("Chalkboard SE", size: 18))
                                                .padding(.top, 4)
                                        }
                       
                            
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
        .sheet(isPresented: $showFriendsPicker, onDismiss: {
            if !selectedFriends.isEmpty {
                showMoodShareCard = true
            }
        }) {
            FriendsPickerView(friends: friends, selectedFriends: $selectedFriends, isPresented: $showFriendsPicker)
        }
        .sheet(isPresented: $showMoodShareCard) {
            MoodShareCardView(
                mood: moodForToday()!,
                selectedFriends: selectedFriends,
                isPresented: $showMoodShareCard
            )
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

struct MoodShareCardView: View {
    let mood: Mood
    let selectedFriends: [Friend]
    @Binding var isPresented: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Share Your Mood")
                .font(.custom("Chalkboard SE", size: 24))
                .padding(.top)
                .multilineTextAlignment(.center)
            
            Text("Mood: \(mood.moodLevel)")
                .font(.custom("Chalkboard SE", size: 20))
                .multilineTextAlignment(.center)
            
            Text("Time: \(timeFormatter.string(from: mood.date))")
                .font(.custom("Chalkboard SE", size: 20))
                .multilineTextAlignment(.center)
            
            // Display notes if available
            if !mood.notes.isEmpty {
                Text("Notes: \(mood.notes)")
                    .font(.custom("Chalkboard SE", size: 20))
                    .padding(.top, 4)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            HStack {
                Button(action: {
                    // Handle share confirmation logic here
                    isPresented = false
                }) {
                    Text("Confirm")
                        .font(.custom("Chalkboard SE", size: 18))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("primaryMauve"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    isPresented = false
                }) {
                    Text("Cancel")
                        .font(.custom("Chalkboard SE", size: 18))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .center)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color("primaryMauve"), Color("secondaryLilac")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 4)
        .padding()
    }
    
    // Time formatter
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
}


