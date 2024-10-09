//
//  SettingsView.swift
//  a2_s3911598
//
//  Created by Lea Wang on 7/10/2024.
//

import SwiftUI
import Auth0

struct SettingsView: View {
    var userProfile: Profile
    var logoutAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // show welcome user
            HStack {
                Text("Welcome, \(userProfile.name)")
                    .font(.title2)
                    .bold()
                    .padding()
                Spacer()
            }
            
            // setting
            NavigationLink(destination: GeneralView()) {
                            SettingItemView(iconName: "wrench.fill", title: "General", backgroundColor: Color.gray.opacity(0.2))
                        }
            SettingItemView(iconName: "lock.fill", title: "Privacy", backgroundColor: Color.blue.opacity(0.2))
            SettingItemView(iconName: "doc.text.fill", title: "About Us", backgroundColor: Color.yellow.opacity(0.2))
            
            Spacer()
            
            // log out button
            // TODO: change it to a beauty layout
            Button(action: {
                logoutAction()
            }) {
                Text("Logout")
                    .font(Font.custom("Chalkboard SE", size: 18))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("primaryMauve"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding()
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground))
    }
}

struct SettingItemView: View {
    let iconName: String
    let title: String
    let backgroundColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .frame(width: 40, height: 40)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.leading, 10)
            
            Text(title)
                .font(.headline)
                .padding(.leading, 10)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .padding(.trailing, 10)
        }
        .frame(height: 60)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}






