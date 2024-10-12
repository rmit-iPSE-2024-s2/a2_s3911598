//
//  MoodDetailView.swift
//  a2_s3911598
//
//  Created by Lea Wang on 3/10/2024.
//


import SwiftUI

/// The `MoodDetailView` struct allows users to review and save their mood for the current date.
///
/// This view displays the current date, the selected mood, an image representing the mood, and allows users to input additional mood notes. It provides a button to save the mood to the data model.

struct MoodDetailView: View {
    /// The environment model context used for managing mood data.
    @Environment(\.modelContext) private var modelContext
    
    /// The text entered by the user to describe their mood.
    @State private(set) var moodText: String = "" // Allow reading moodText in tests
    
    /// A binding that controls whether this view is active.
    @Binding var isActive: Bool
    
    /// The mood selected by the user.
    @Binding var selectedMood: String
    
    /// The current date, used to record the mood.
    let currentDate = Date()

    var body: some View {
        VStack(alignment: .center) {
            // Display current date
            Text(currentDate, formatter: dateFormatter)
                .font(Font.custom("Chalkboard SE", size: 18))
                .padding(.top, 20)

            // Display the selected mood image
            Image(imageName(for: selectedMood))
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.top, 20)

            // Display selected mood label
            Text("“ \(selectedMood) ”")
                .font(Font.custom("Chalkboard SE", size: 30))
                .fontWeight(.bold)
                .padding(.vertical, 10)

            // Display mood description text
            Text(displayText(for: selectedMood))
                .font(Font.custom("Chalkboard SE", size: 18))
                .padding(.bottom, 10)
                .padding(.horizontal)
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)

            // Input mood notes
            TextField("Write down your mood", text: $moodText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(Font.custom("Chalkboard SE", size: 16))
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)

            Spacer()

            // Done button
            Button(action: {
                self.isActive = false
                self.saveMood()
                print("123")
            }) {
                HStack {
                    Spacer()
                    Text("Done")
                        .font(Font.custom("Chalkboard SE", size: 20))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(Color("primaryMauve")) 
                .cornerRadius(10)
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal)
        .background(Color(UIColor.systemGray5).edgesIgnoringSafeArea(.all))
    }

    // Helper function: returns image name based on mood label
    func imageName(for mood: String) -> String {
        switch mood {
        case "Slightly pleasant":
            return "SlightlyPleasant"
        case "Pleasant":
            return "Happy"
        case "Very pleasant":
            return "VeryHappy"
        case "Very Unpleasant":
            return "VeryUnpleasant"
        case "Slightly UnPleasant":
            return "SlightlyUnPleasant"
        case "Unpleasant":
            return "Unpleasant"
        default:
            return "Normal"
        }
    }

    // Helper function: returns description text based on mood label
    
    /// - Parameter mood: The mood selected by the user.
    /// - Returns: A text description of the mood.
    func displayText(for mood: String) -> String {
        switch mood.lowercased() {  // Convert mood to lowercase
        case "slightly pleasant":
            return "Keep calm and carry on."
        case "pleasant", "very pleasant":
            return "Good to know you're feeling great."
        case "very unpleasant":
            return "I sometimes feel very bad too, I understand how oppressively heavy that can feel."
        case "slightly unpleasant":
            return "I have been just ok at times as well."
        default:
            return "Good to know you're feeling \(mood.lowercased())!"
        }
    }
    
    /// Saves the selected mood and notes to the model context.
    ///
    /// This function creates a new `Mood` instance using the selected mood and user notes, and inserts it into the model context.
    func saveMood() {
        let newMood = Mood(date: currentDate, moodLevel: selectedMood, notes: moodText)
        modelContext.insert(newMood)
    }
}

