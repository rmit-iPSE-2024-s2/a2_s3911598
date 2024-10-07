//
//  GeneralView.swift
//  a2_s3911598
//
//  Created by Lea Wang on 7/10/2024.
//

import SwiftUI

struct GeneralView: View {
    var body: some View {
        VStack(spacing: 20) {
            NavigationLink(destination: ColorThemeView()) {
                SettingItemView(iconName: "paintpalette.fill", title: "Color Theme", backgroundColor: Color.orange.opacity(0.2))
            }
            
            SettingItemView(iconName: "bell.fill", title: "Notifications", backgroundColor: Color.green.opacity(0.2))
            
            SettingItemView(iconName: "globe", title: "Language", backgroundColor: Color.purple.opacity(0.2))
            
            Spacer()
        }
        .padding()
        .navigationTitle("General Setting")
    }
}
