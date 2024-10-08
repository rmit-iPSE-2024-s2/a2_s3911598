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

    var body: some View {
        VStack(alignment: .leading) {
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
                        .padding(.trailing, 16)
                }
            }

            List {
                Section(header: Text("Friends List").font(.custom("Chalkboard SE", size: 20)).padding(.top, -10)) {
                    ForEach(friends, id: \.id) { friend in
                        Text("\(friend.name) - \(friend.email)")
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    deleteFriend(friend)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.gray)
                            }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .sheet(isPresented: $showingAddFriendView) {
                AddFriendView(isPresented: $showingAddFriendView)
            }
        }
    }

    private func deleteFriend(_ friend: Friend) {
        modelContext.delete(friend)
    }
}
                   

