import SwiftUI
import SwiftData

/// The `FriendsPickerView` struct allows users to select friends to share tasks or other content with.
///
/// If no friends are available, it provides an option to add new friends. After selecting friends, users can confirm the selection and share with the selected friends. If no friends are selected, an alert is displayed. An animated heart effect shows success when the sharing action is completed.
struct FriendsPickerView: View {

    /// The list of friends available for selection.
    let friends: [Friend]

    /// A binding that stores the selected friends.
    @Binding var selectedFriends: [Friend]

    /// A binding that controls whether the view is presented.
    @Binding var isPresented: Bool

    /// Controls the presentation of the `AddFriendView`.
    @State private var showingAddFriendView = false

    /// Controls whether the share result is shown.
    @State private var showShareResult = false

    /// The message displayed when sharing is successful.
    @State private var shareMessage = ""

    /// Controls the animation of hearts when sharing is successful.
    @State private var heartAnimation = false

    /// Controls whether the selection error alert is shown.
    @State private var showSelectionError = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading, spacing: 10) {
                    // If there are no friends available
                    if friends.isEmpty {
                        VStack {
                            Text("You don't have any friends yet.")
                                .font(.custom("Chalkboard SE", size: 18))
                                .padding()

                            Button(action: {
                                showingAddFriendView = true
                            }) {
                                Text("Add Friends")
                                    .font(.custom("Chalkboard SE", size: 18))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("primaryMauve"))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding()
                            }

                            Button(action: {
                                isPresented = false
                            }) {
                                Text("Close")
                                    .font(.custom("Chalkboard SE", size: 18))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .padding()
                            }
                        }
                    } else {
                        // Friends list for selection
                        Text("Select Friends")
                            .font(.custom("Chalkboard SE", size: 24))
                            .padding([.leading], 16)
                            .padding([.top], 20)
                            .padding([.bottom], 10)

                        List {
                            ForEach(friends) { friend in
                                HStack {
                                    Text(friend.name)
                                        .font(.custom("Chalkboard SE", size: 18))
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                                .padding()
                                .background(selectedFriends.contains(where: { $0.id == friend.id }) ? Color("primaryMauve") : Color("secondaryLilac"))
                                .cornerRadius(8)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    toggleFriendSelection(friend)
                                }
                            }
                            .listRowInsets(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(PlainListStyle())

                        // Confirm button for sharing
                        Button(action: {
                            if selectedFriends.isEmpty {
                                showSelectionError = true
                            } else {
                                shareMessage = "Successfully shared with \(selectedFriends.map { $0.name }.joined(separator: ", "))"
                                withAnimation(.spring()) {
                                    showShareResult = true
                                    heartAnimation = true
                                }

                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    withAnimation {
                                        showShareResult = false
                                        heartAnimation = false
                                        isPresented = false
                                    }
                                }
                            }
                        }) {
                            Text("OK")
                                .font(.custom("Chalkboard SE", size: 18))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("primaryMauve"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding([.leading, .trailing], 16)
                                .padding(.top, 10)
                        }
                        .alert(isPresented: $showSelectionError) {
                            Alert(
                                title: Text("No Friends Selected"),
                                message: Text("Please select at least one friend to share with."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                }

                // Share result overlay with animated hearts
                if showShareResult {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)

                    VStack {
                        Text(shareMessage)
                            .font(.custom("Chalkboard SE", size: 18))
                            .padding()
                            .background(Color("primaryMauve"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding()
                            .transition(.move(edge: .bottom))

                        ZStack {
                            ForEach(0..<20, id: \.self) { index in
                                HeartView()
                                    .offset(
                                        x: CGFloat.random(in: -150...150),
                                        y: heartAnimation ? CGFloat.random(in: -300...(-50)) : 300
                                    )
                                    .opacity(heartAnimation ? 0 : 1)
                                    .scaleEffect(heartAnimation ? 1.5 : 1.0)
                                    .animation(
                                        Animation.easeInOut(duration: 2.5)
                                            .delay(Double(index) * 0.1),
                                        value: heartAnimation
                                    )
                            }
                        }
                    }
                    .onTapGesture {
                        withAnimation {
                            showShareResult = false
                            heartAnimation = false
                            isPresented = false
                        }
                    }
                }
            }
            .sheet(isPresented: $showingAddFriendView) {
                AddFriendView(isPresented: $showingAddFriendView)
            }
        }
    }

    /// Toggles the selection state of the given friend.
    ///
    /// - Parameter friend: The friend to toggle selection for.
    private func toggleFriendSelection(_ friend: Friend) {
        if let index = selectedFriends.firstIndex(where: { $0.id == friend.id }) {
            selectedFriends.remove(at: index)
        } else {
            selectedFriends.append(friend)
        }
    }
}

/// A custom view that displays a heart symbol used in the share result animation.
struct HeartView: View {
    var body: some View {
        Image(systemName: "heart.fill")
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundColor(.red)
            .opacity(0.8)
    }
}
