//
//  FriendsPickerView.swift
//  a2_s3911598
//
//  Created by zachary.zhao on 8/10/2024.
//

import SwiftUI
import SwiftData
struct FriendsPickerView: View {
    let friends: [Friend]
    @Binding var selectedFriends: [Friend]
    
    var body: some View {
        NavigationView {
            if friends.isEmpty {
                VStack {
                    Text("You don't have any friends yet.")
                        .font(.custom("Chalkboard SE", size: 18))
                        .padding()
                    
                    Button(action: {
                    }) {
                        Text("Add Friends")
                            .font(.custom("Chalkboard SE", size: 18))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                    }
                    
                    Button(action: {
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
                List {
                    ForEach(friends) { friend in
                        HStack {
                            Text(friend.name)
                            Spacer()
                            if selectedFriends.contains(where: { $0.id == friend.id }) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .onTapGesture {
                            toggleFriendSelection(friend)
                        }
                    }
                }
                .navigationTitle("Select Friends")
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

