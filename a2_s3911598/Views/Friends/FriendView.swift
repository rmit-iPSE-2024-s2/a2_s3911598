//
//  FriendView.swift
//  a2_s3911598
//
//  Created by lea.Wang on 8/10/2024.
//



import SwiftUI
import SwiftData

struct FriendView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Friend.name, order: .forward) private var friends: [Friend]
    
    @State private var showingAddFriendView = false
    @State private var showDeleteConfirmation = false
    @State private var friendToDelete: Friend?

    var body: some View {
        VStack(alignment: .leading) {
            // Header with title and add button
            HStack {
                Text("Friends")
                    .font(.custom("Chalkboard SE", size: 24))
                    .padding([.leading, .top], 16)
                
                Spacer()
                
                Button(action: {
                    showingAddFriendView = true
                }) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(Color.purple)
                }
                .padding(.trailing, 16)


            }
            Divider()
                .background(Color.gray)
                .padding(.horizontal)

            // Friends list or empty view
            if friends.isEmpty {
                VStack {
                    Text("No friends added yet!")
                        .font(.custom("Chalkboard SE", size: 18))
                        .foregroundColor(.gray)
                        .padding()

                    Button(action: {
                        showingAddFriendView = true
                    }) {
                        Text("Add Your First Friend")
                            .font(.custom("Chalkboard SE", size: 18))
                            .padding()
                            .background(Color("primaryMauve"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    Section(header: Text("Friends List")
                        .font(.custom("Chalkboard SE", size: 20))
                        .padding(.top, -10)
                    ) {
                        ForEach(friends, id: \.id) { friend in
                            HStack {
                                Circle()
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Text(friend.name.prefix(1))
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    )
                                
                                VStack(alignment: .leading) {
                                    Text(friend.name)
                                        .font(.custom("Chalkboard SE", size: 18))
                                        .foregroundColor(.primary)
                                    Text(friend.email)
                                        .font(.custom("Chalkboard SE", size: 14))
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 1)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    friendToDelete = friend
                                    showDeleteConfirmation = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.gray)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .sheet(isPresented: $showingAddFriendView) {
            AddFriendView(isPresented: $showingAddFriendView)
        }
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Delete Friend"),
                message: Text("Are you sure you want to delete \(friendToDelete?.name ?? "this friend")?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let friend = friendToDelete {
                        deleteFriend(friend)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }

    private func deleteFriend(_ friend: Friend) {
        modelContext.delete(friend)
    }
}

                   

