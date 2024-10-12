//
//  ProfileView.swift
//  a2_s3911598
//
//  Created by Lea Wang on 12/10/2024.
//

import SwiftUI

struct ProfileView: View {
    @Binding var username: String
    @State private var showAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Profile")
                .font(.system(size: 34, weight: .bold))
                .padding(.top, 40)
                .padding(.bottom, 20)

            // Username input field
            Text("Username")
                .font(.headline)
                .foregroundColor(.primary)

            TextField("Enter your username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            // Save button
            Button(action: {
                saveUsername()  // Save user name to UserDefaults
                showAlert = true
            }) {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("primaryMauve"))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Success"), message: Text("Your username has been saved!"), dismissButton: .default(Text("OK")))
            }

            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
    }

    // save user name to UserDefaults
    func saveUsername() {
        UserDefaults.standard.set(username, forKey: "username")
        print("Username saved: \(username)")
    }
}


