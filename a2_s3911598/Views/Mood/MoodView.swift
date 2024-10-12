//
//  MoodDetailView.swift
//  a2_s3911598
//
//  Created by Lea Wang on 3/10/2024.
//


import SwiftUI
import Charts
import SwiftData

/// The `MoodView` struct provides an interface for tracking and displaying the user's mood records.
///
/// This view allows users to view their daily mood records, record new moods, display a motivational quote, and share mood data with friends. It interacts with the `Mood` model to fetch and display mood data, and uses `QuoteModel` to fetch random quotes from an API.
struct MoodView: View {
    
    /// Controls whether the calendar view is shown.
    @State private var showCalendar = false
    
    /// Controls whether the mood tracking view is shown.
    @State private var showMoodTracking = false
    
    /// Indicates if the view is currently active.
    @State private var isActive = false
    
    /// A list of selected friends to share mood data with.
    @State private var selectedFriends: [Friend] = []
    
    /// Controls whether the friends picker is shown.
    @State private var showFriendsPicker = false
    
    @State private var heartBeat = false
    
    @State private var username: String = UserDefaults.standard.string(forKey: "username") ?? "Default User"
    
    /// The user's profile, containing basic user information.
    var userProfile: Profile
    
    /// The model responsible for fetching random quotes.
    @ObservedObject var quoteModel: QuoteModel = QuoteModel()
    
    /// The environment's model context used for interacting with the `Mood` data model.
    @Environment(\.modelContext) private var defaultModelContext
    
    /// A query that fetches the mood data, sorted by date in descending order.
    @Query(sort: \Mood.date, order: .reverse) private var moodDataFromContext: [Mood]
    var injectedMoodData: [Mood]?

    
    /// A query that fetches the list of friends.
    @Query private var friends: [Friend]
    
    /// Initializes the `MoodView` with a user's profile and the model context.
    ///
    /// - Parameters:
    ///   - userProfile: The profile of the current user.
    ///   - modelContext: The model context for managing data.
    init(userProfile: Profile, injectedMoodData: [Mood]? = nil) {
        self.userProfile = userProfile
        self.injectedMoodData = injectedMoodData
    }

    var body: some View {
        let moodData = injectedMoodData ?? moodDataFromContext
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Moods")
                    .font(.custom("Chalkboard SE", size: 24))
                    .padding([.leading, .top], 16)

                // Dynamically display the username
                Text("Welcome, \(username.isEmpty ? userProfile.name : username)")
                    .font(.custom("Chalkboard SE", size: 16))
                    .bold()
                    .padding([.leading], 16)
                    .padding([.top], -10)
                
                // Displays a random motivational quote
                VStack(alignment: .leading) {
                    if let quote = quoteModel.result {
                        Text("\"\(quote.q)\"")
                            .font(.custom("Chalkboard SE", size: 16))
                            .multilineTextAlignment(.leading)
                            .onTapGesture {
                                quoteModel.fetchQuote()
                            }
                    }
                }
                .padding([.leading, .trailing])
                .padding([.top], -10)
                .frame(minHeight: 40, maxHeight: 90, alignment: .top)

                // Recent mood record section
                cardView {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                                .scaleEffect(heartBeat ? 1.2 : 1.0)  // Set the scaling effect for heartbeat animation
                                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: heartBeat)  // Loop the heartbeat animation
                                .onAppear {
                                    heartBeat = true  // Start the animation when the view appears
                                }

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

                // "How do you feel today" card with mood tracking
                cardView {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("How do you feel today?")
                                .font(Font.custom("Chalkboard SE", size: 26))
                            Spacer()
                        }
                        .padding(.horizontal)
                        
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
                if let todayMood = moodForToday(moodData: moodData) {
                    cardView {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Today's Mood Record")
                                .font(Font.custom("Chalkboard SE", size: 20))
                            
                            Text("Time: \(timeFormatter.string(from: todayMood.date))")
                                .font(Font.custom("Chalkboard SE", size: 18))
                            
                            Text("Mood: \(todayMood.moodLevel)")
                                .font(Font.custom("Chalkboard SE", size: 18))

                            
                            if !todayMood.notes.isEmpty {
                                Text("Notes: \(todayMood.notes)")
                                    .font(Font.custom("Chalkboard SE", size: 18))
                                    .padding(.top, 4)
                            }
                            
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
            FriendsPickerView(friends: friends, selectedFriends: $selectedFriends, isPresented: $showFriendsPicker)
        }
        .background(Color("AppBackground").edgesIgnoringSafeArea(.all))
        .onAppear {
            quoteModel.fetchQuote()
            if let savedUsername = UserDefaults.standard.string(forKey: "username") {
                            username = savedUsername
                        }
        }
    }

    /// Retrieves today's mood record from the list of mood data.
    ///
    /// - Returns: The `Mood` instance for today's date, if available.
    func moodForToday(moodData: [Mood]) -> Mood? {
        let moodsForToday = moodData.filter { Calendar.current.isDateInToday($0.date) }
        return moodsForToday.sorted(by: { $0.date > $1.date }).first
    }


    /// A time formatter for formatting mood record times.
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }

    /// A reusable card view style used for various sections in the view.
    ///
    /// - Parameter content: The content to be displayed inside the card.
    /// - Returns: A styled card view.
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
