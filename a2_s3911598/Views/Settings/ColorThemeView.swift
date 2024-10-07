//
//  ColorThemeView.swift
//  a2_s3911598
//
//  Created by Lea Wang on 7/10/2024.
//

import SwiftUI

struct ColorThemeView: View {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select a Color Theme")
                .font(.headline)
            
            HStack {
                Button(action: {
                    isDarkMode = false
                }) {
                    Text("Light")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isDarkMode ? Color.gray.opacity(0.2) : Color.blue.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    isDarkMode = true
                }) {
                    Text("Dark")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isDarkMode ? Color.blue.opacity(0.8) : Color.gray.opacity(0.2))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Color Theme")
    }
}

