import SwiftUI

struct MoodTrackingView: View {
    @Binding var isActive: Bool

    @State private var moodValue: Double = 0.5
    @State private var selectedMoodLabel = "Neutral"
    @State private var showingMoodDetailView = false
    @State private var eyeOffsetX: CGFloat = 0  // Horizontal offset of the eyes

    // Mood color gradient
    let moodColors = [
        Color(red: 0.68, green: 0.77, blue: 0.89),
        Color(red: 0.74, green: 0.83, blue: 0.91),
        Color(red: 0.79, green: 0.88, blue: 0.94),
        Color(red: 0.93, green: 0.88, blue: 0.68),
        Color(red: 0.98, green: 0.86, blue: 0.53),
        Color(red: 0.99, green: 0.80, blue: 0.67),
        Color(red: 0.99, green: 0.70, blue: 0.63)
    ]

    // Mood description labels
    let moodLabels = [
        "Very Unpleasant",
        "Unpleasant",
        "Slightly Unpleasant",
        "Neutral",
        "Slightly Pleasant",
        "Pleasant",
        "Very Pleasant"
    ]

    var curvature: Double {
        return (moodValue - 0.5) * 2
    }

    var body: some View {
        ZStack {
            // Set background gradient color based on moodValue
            moodColors[Int(moodValue * Double(moodColors.count - 1))]
                .edgesIgnoringSafeArea(.all)
                .animation(.easeInOut, value: moodValue)

            VStack(spacing: 20) {
                Spacer(minLength: 50)

                // Facial expression, including eyes, nose, and mouth
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

                ZStack {
                    Slider(value: $moodValue)
                        .padding(.horizontal)

                    // Mood label that changes with the slider
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

                // Save mood and open detail page
                Button(action: {
                    // update selectedMoodLabel
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

// Custom mouth shape
struct MouthShape: Shape {
    var curvature: Double  // From -1 (frown) to 1 (smile)

    // Make curvature property animatable
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
