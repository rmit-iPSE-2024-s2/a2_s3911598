//
//  MoodDetailView.swift
//  a2_s3911598
//
//  Created by Lea Wang on 3/10/2024.
//


import SwiftUI

/// The `MoodTrackingView` struct provides a user interface for tracking the user's mood using a slider.
///
/// This view allows users to adjust their mood on a scale from "Very Unpleasant" to "Very Pleasant" using a slider, and updates the facial expression and background color accordingly. Once the user selects their mood, they can proceed to the next view to record additional details.
struct MoodTrackingView: View {
    
    /// A binding to control whether the view is active.
    @Binding var isActive: Bool
    
    /// The current value of the mood slider (0.0 to 1.0).
    @State private var moodValue: Double = 0.5
    
    /// The label representing the currently selected mood.
    @State private var selectedMoodLabel = "Neutral"
    
    /// Controls whether the mood detail view is presented.
    @State private var showingMoodDetailView = false
    
    /// The horizontal offset for the eyes in the facial expression.
    @State private var eyeOffsetX: CGFloat = 0
    
    /// A gradient of colors corresponding to different mood levels.
    let moodColors = [
        Color(red: 0.68, green: 0.77, blue: 0.89),
        Color(red: 0.74, green: 0.83, blue: 0.91),
        Color(red: 0.79, green: 0.88, blue: 0.94),
        Color(red: 0.93, green: 0.88, blue: 0.68),
        Color(red: 0.98, green: 0.86, blue: 0.53),
        Color(red: 0.99, green: 0.80, blue: 0.67),
        Color(red: 0.99, green: 0.70, blue: 0.63)
    ]
    
    /// Labels describing different mood levels.
    let moodLabels = [
        "Very Unpleasant",
        "Unpleasant",
        "Slightly Unpleasant",
        "Neutral",
        "Slightly Pleasant",
        "Pleasant",
        "Very Pleasant"
    ]
    
    /// The curvature of the mouth, where -1 represents a frown and 1 represents a smile.
    var curvature: Double {
        return (moodValue - 0.5) * 2
    }

    var body: some View {
        ZStack {
            // Background color changes based on moodValue
            moodColors[Int(moodValue * Double(moodColors.count - 1))]
                .edgesIgnoringSafeArea(.all)
                .animation(.easeInOut, value: moodValue)

            VStack(spacing: 20) {
                Spacer(minLength: 50)

                // Facial expression with eyes, nose, and mouth
                ZStack {
                    // Eyes
                    HStack(spacing: 20) {
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                            .overlay(
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.black)
                                    .offset(x: eyeOffsetX)
                            )
                        Circle()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.white)
                            .overlay(
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.black)
                                    .offset(x: eyeOffsetX)
                            )
                    }
                    // Nose
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color.orange)
                        .offset(y: 50)
                    // Mouth
                    MouthShape(curvature: curvature)
                        .stroke(Color.black, lineWidth: 5)
                        .frame(width: 200, height: 100)
                        .offset(y: 130)
                        .animation(.easeInOut, value: curvature)
                }.offset(y: -100)

                // Mood slider with a label that changes based on moodValue
                ZStack {
                    Slider(value: $moodValue)
                        .padding(.horizontal)

                    Text(moodLabels[Int(moodValue * Double(moodLabels.count - 1))])
                        .font(Font.custom("Chalkboard SE", size: 20))
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .offset(x: (CGFloat(moodValue) - 0.5) * 300, y: -50)
                        .animation(.easeInOut, value: moodValue)
                }.offset(y: 100)

                // Mood description labels
                HStack {
                    Text("Very Unpleasant")
                        .font(Font.custom("Chalkboard SE", size: 14))
                        .foregroundColor(.gray)
                    Spacer()
                    Text("Very Pleasant")
                        .font(Font.custom("Chalkboard SE", size: 14))
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                .offset(y: 100)

                Spacer()

                // Button to save the mood and navigate to the mood detail view
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
                    .background(Color("primaryMauve"))
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

/// A custom shape representing the mouth in the mood facial expression.
///
/// The `MouthShape` changes its curvature based on the `curvature` value, where -1 represents a frown and 1 represents a smile.
struct MouthShape: Shape {
    
    /// The curvature of the mouth, ranging from -1 (frown) to 1 (smile).
    var curvature: Double
    
    // Make `curvature` animatable.
    var animatableData: Double {
        get { curvature }
        set { curvature = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        let smileHeight = CGFloat(curvature) * height / 2
        
        let startPoint = CGPoint(x: 0, y: height / 2)
        let endPoint = CGPoint(x: width, y: height / 2)
        let controlPoint1 = CGPoint(x: width / 4, y: height / 2 + smileHeight)
        let controlPoint2 = CGPoint(x: 3 * width / 4, y: height / 2 + smileHeight)
        
        path.move(to: startPoint)
        path.addCurve(to: endPoint, control1: controlPoint1, control2: controlPoint2)
        
        return path
    }
}
