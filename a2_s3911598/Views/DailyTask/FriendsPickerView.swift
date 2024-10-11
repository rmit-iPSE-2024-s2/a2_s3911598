import SwiftUI
import SwiftData

struct FriendsPickerView: View {
    let friends: [Friend]
    @Binding var selectedFriends: [Friend]
    @State private var showingAddFriendView = false
    @Binding var isPresented: Bool
    @State private var showShareResult = false
    @State private var shareMessage = ""
    @State private var heartAnimation = false
    @State private var showSelectionError = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading, spacing: 10) {
                    if friends.isEmpty {
                        // If no friends are available, display a message and options to add friends or close the view
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
                        // Display list of friends for selection
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
                        
                        // Button to confirm selection and share with selected friends
                        Button(action: {
                            if selectedFriends.isEmpty {
                                // Show an alert if no friends are selected
                                showSelectionError = true
                            } else {
                                shareMessage = "Successfully shared with \(selectedFriends.map { $0.name }.joined(separator: ", "))"
                                withAnimation(.spring()) {
                                    showShareResult = true
                                    heartAnimation = true
                                }
                                
                                // Show share result for 3 seconds, then close the view
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
                
                // Share result overlay with animation
                if showShareResult {
                    Color.black.opacity(0.4) // Background blur effect
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
                        
                        // Heart animation when sharing is successful
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
                        // Close the share result view on tap
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

    // Toggle friend selection state
    private func toggleFriendSelection(_ friend: Friend) {
        if let index = selectedFriends.firstIndex(where: { $0.id == friend.id }) {
            selectedFriends.remove(at: index)
        } else {
            selectedFriends.append(friend)
        }
    }
}

// View for the animated hearts
struct HeartView: View {
    var body: some View {
        Image(systemName: "heart.fill")
            .resizable()
            .frame(width: 20, height: 20)
            .foregroundColor(.red)
            .opacity(0.8)
    }
}
