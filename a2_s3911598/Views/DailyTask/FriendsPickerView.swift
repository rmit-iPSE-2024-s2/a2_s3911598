import SwiftUI
import SwiftData

struct FriendsPickerView: View {
    let friends: [Friend]
    @Binding var selectedFriends: [Friend]
    @State private var showingAddFriendView = false
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                // 自定义标题
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
                    Text("Select Friends")
                        .font(.custom("Chalkboard SE", size: 24))
                        .padding([.leading], 16)
                        .padding([.top],20)
                        .padding([.bottom],10)
                    
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
                    
                    Button(action: {
                        isPresented = false 
                    }) {
                        Text("Done")
                            .font(.custom("Chalkboard SE", size: 18))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("primaryMauve"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding([.leading, .trailing], 16)
                            .padding(.top, 10)
                    }
                }
            }
            .sheet(isPresented: $showingAddFriendView) {
                AddFriendView(isPresented: $showingAddFriendView)
            }
        }
    }

    private func toggleFriendSelection(_ friend: Friend) {
        if let index = selectedFriends.firstIndex(where: { $0.id == friend.id }) {
            selectedFriends.remove(at: index)
        } else {
            selectedFriends.append(friend)
        }
    }
}
