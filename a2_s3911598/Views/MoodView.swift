//
//  CalendarView.swift
//  a1_s3911598
//
//  Created by Lea Wang on 27/8/2024.
//


import SwiftUI
import Charts

struct MoodView: View {
    @State private var showCalendar = false
    @State private var showMoodTracking = false
    @State private var isActive = false
    
    // Sample data for the chart
    let moodData: [MoodEntry] = [
        MoodEntry(date: "Aug 25", mood: .veryPleasant),
        MoodEntry(date: "Aug 26", mood: .pleasant),
        MoodEntry(date: "Aug 27", mood: .neutral),
        MoodEntry(date: "Aug 28", mood: .unpleasant),
        MoodEntry(date: "Aug 29", mood: .veryUnpleasant),
        MoodEntry(date: "Aug 30", mood: .pleasant)
    ]
    
    // Sample data for today's mood records
    let moodRecords: [MoodRecord] = [
        MoodRecord(time: "08:30 AM", mood: .pleasant),
        MoodRecord(time: "12:45 PM", mood: .neutral),
        MoodRecord(time: "03:20 PM", mood: .unpleasant)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Moods")
                    .font(.custom("Chalkboard SE", size: 24))
                    .padding([.leading, .top], 16)
                
                // My daily mood record section
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
                        }
                        .padding(.horizontal)

                        HStack(alignment: .top) {
                            Image("unpleasant") // Replace image name
                                .resizable()
                                .frame(width: 50, height: 50)
                            VStack(alignment: .leading) {
                                Text("Recent")
                                    .font(Font.custom("Chalkboard SE", size: 16))
                                    .foregroundColor(.gray)
                                Text("08-30")
                                    .font(Font.custom("Chalkboard SE", size: 14))
                                Text("Very unpleasant")
                                    .font(Font.custom("Chalkboard SE", size: 20))
                                    .foregroundColor(.primary)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("Mood tracking")
                                    .font(Font.custom("Chalkboard SE", size: 20))
                                Spacer()
                                Button(action: {
                                    showMoodTracking = true
                                }) {
                                    HStack {
                                        Text("Go record")
                                            .font(Font.custom("Chalkboard SE", size: 16))
                                        Image(systemName: "pencil")
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 10)
                                    .background(Color("primaryMauve"))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .contentShape(Rectangle())
                                }
                                .shadow(radius: 2)
                                .sheet(isPresented: $showMoodTracking) {
                                    MoodTrackingView(isActive: $showMoodTracking)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                
                // Recent mood distribution section
                cardView {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("🌼 Recent mood distribution")
                                .font(Font.custom("Chalkboard SE", size: 20))
                            Spacer()
                        }
                        .padding(.horizontal)

                        // Chart to display mood data
                        Chart {
                            ForEach(moodData) { entry in
                                BarMark(
                                    x: .value("Date", entry.date),
                                    y: .value("Mood Level", entry.mood.rawValue)
                                )
                                .foregroundStyle(by: .value("Mood", entry.mood.description))
                            }
                        }
                        .frame(height: 200)
                        .padding()
                    }
                    .padding(.vertical)
                }
                
                // Today's mood record section
                cardView {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Today")
                                .font(Font.custom("Chalkboard SE", size: 14))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 4)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(5)
                            Spacer()
                            Text(Date(), style: .date)
                                .font(Font.custom("Chalkboard SE", size: 20))
                        }
                        .padding(.horizontal)
                        
                        if moodRecords.isEmpty {
                            VStack {
                                Image("no_record") // Replace with actual image name
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 150)
                                Text("No Record")
                                    .font(Font.custom("Chalkboard SE", size: 20))
                                    .foregroundColor(.gray)
                            }
                            .padding(.top, 20)
                        } else {
                            ForEach(moodRecords) { record in
                                HStack {
                                    Text(record.time)
                                        .font(Font.custom("Chalkboard SE", size: 20))
                                    Spacer()
                                    HStack {
                                        Text(record.mood.description)
                                            .font(Font.custom("Chalkboard SE", size: 16))
                                        Image(systemName: record.mood.iconName)
                                    }
                                    .padding(6)
                                    .background(record.mood.color.opacity(0.2))
                                    .cornerRadius(10)
                                }
                                .padding(.vertical, 5)
                            }
                        }
                    }
                    .padding(.vertical)
                }
                
                Spacer()
            }
        }
        .background(Color("AppBackground").edgesIgnoringSafeArea(.all))
    }
    
    // Unified card view style
    @ViewBuilder
    func cardView<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white) // or Color("CardBackground") for a custom color
                .shadow(radius: 5)
                .padding(.horizontal)
            
            content()
                .padding()
        }
    }
}

struct MoodEntry: Identifiable {
    let id = UUID()
    let date: String
    let mood: MoodLevel
}

struct MoodRecord: Identifiable {
    let id = UUID()
    let time: String
    let mood: MoodLevel
}

enum MoodLevel: Int {
    case veryUnpleasant = 1
    case unpleasant = 2
    case neutral = 3
    case pleasant = 4
    case veryPleasant = 5
    
    var description: String {
        switch self {
        case .veryUnpleasant:
            return "Very Unpleasant"
        case .unpleasant:
            return "Unpleasant"
        case .neutral:
            return "Neutral"
        case .pleasant:
            return "Pleasant"
        case .veryPleasant:
            return "Very Pleasant"
        }
    }
    
    var iconName: String {
        switch self {
        case .veryUnpleasant:
            return "face.dashed"
        case .unpleasant:
            return "face.smiling"
        case .neutral:
            return "face.neutral"
        case .pleasant:
            return "face.smiling.fill"
        case .veryPleasant:
            return "face.sunglasses"
        }
    }
    
    var color: Color {
        switch self {
        case .veryUnpleasant:
            return .red
        case .unpleasant:
            return .orange
        case .neutral:
            return .gray
        case .pleasant:
            return .green
        case .veryPleasant:
            return .blue
        }
    }
}

extension View {
    func responsiveLayout() -> some View {
        self.modifier(ResponsiveLayout())
    }
}

struct ResponsiveLayout: ViewModifier {
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .padding(.horizontal, geometry.size.width > 600 ? 30 : 15)
                .padding(.vertical, geometry.size.width > 600 ? 20 : 10)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

struct MoodTrackingView: View {
    @Binding var isActive: Bool
    @State private var moodValue: Double = 0.5
    @State private var showingMoodDetailView = false
    @State private var selectedMoodLabel = "Neutral"
    
    let moodColors = [
        Color(red: 0.68, green: 0.77, blue: 0.89),
        Color(red: 0.74, green: 0.83, blue: 0.91),
        Color(red: 0.79, green: 0.88, blue: 0.94),
        Color(red: 0.93, green: 0.88, blue: 0.68),
        Color(red: 0.98, green: 0.86, blue: 0.53),
        Color(red: 0.99, green: 0.80, blue: 0.67),
        Color(red: 0.99, green: 0.70, blue: 0.63)
    ]
    
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
            moodColors[Int(moodValue * Double(moodColors.count - 1))]
                .edgesIgnoringSafeArea(.all)
                .animation(.easeInOut, value: moodValue)
            
            VStack(spacing: 20) {
                Spacer()
                
                Image("image")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                
                ZStack {
                    Slider(value: $moodValue)
                        .padding(.horizontal)
                    
                    Text(moodLabels[Int(moodValue * Double(moodLabels.count - 1))])
                        .font(Font.custom("Chalkboard SE", size: 20))
                        .padding(.all, 8)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .offset(x: (CGFloat(moodValue) - 0.5) * 300, y: -50) // Adjust the position of the speech bubble
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
                
                Button(action: {
                    self.selectedMoodLabel = moodLabels[Int(moodValue * Double(moodLabels.count - 1))]
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

struct MoodDetailView: View {
    @State private var moodText: String = ""
    @Environment(\.dismiss) var dismiss
    @Binding var isActive: Bool
    @Binding var selectedMood: String
    let currentDate = Date()

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .center) {
            // Show current date
            Text(currentDate, formatter: dateFormatter)
                .font(Font.custom("Chalkboard SE", size: 18))
                .padding(.top, 20)

            // Show the user's selected mood image
            Image(imageName(for: selectedMood))
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.top, 20)

            // Show the selected mood
            Text("“ \(selectedMood) ”")
                .font(Font.custom("Chalkboard SE", size: 30))
                .fontWeight(.bold)
                .padding(.vertical, 10)

            // Display different text based on the selected mood
            Text(displayText(for: selectedMood))
                .font(Font.custom("Chalkboard SE", size: 18))
                .padding(.bottom, 10)
                .padding(.horizontal)
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)

            // Mood input TextField
            TextField("Write down your mood", text: $moodText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(Font.custom("Chalkboard SE", size: 16))
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)

            Spacer()

            // Done button
            Button(action: {
                self.isActive = false  // This will close the MoodTrackingView
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

    // Return the corresponding image name based on the selected mood
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
            return "normal"  // Default image
        }
    }

    // Update the text above based on the user's selected mood
    func displayText(for mood: String) -> String {
        switch mood {
        case "Slightly pleasant":
            return "Keep calm and carry on."
        case "Pleasant", "Very pleasant":
            return "Good to know you're feeling great."
        case "Very unpleasant":
            return "I sometimes feel very bad too, I understand how oppressively heavy that can feel."
        case "Slightly unpleasant":
            return "I have been just ok at times as well."
        default:
            return "Good to know you're feeling \(mood.lowercased())!"
        }
    }
}

struct MoodView_Previews: PreviewProvider {
    static var previews: some View {
        MoodView()
    }
}
