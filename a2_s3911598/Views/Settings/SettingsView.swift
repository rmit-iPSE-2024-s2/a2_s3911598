import SwiftUI
import Auth0

struct SettingsView: View {
    var userProfile: Profile
    var logoutAction: () -> Void
    @ObservedObject var quoteModel = QuoteModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Setting")
                .font(.custom("Chalkboard SE", size: 24))
                .padding([.leading], 16)
            
            // Settings options
            NavigationLink(destination: GeneralView()) {
                SettingItemView(iconName: "wrench.fill", title: "General", backgroundColor: Color.gray.opacity(0.2))
            }
            
            NavigationLink(destination: PrivacyView()) {
                SettingItemView(iconName: "lock.fill", title: "Privacy", backgroundColor: Color.blue.opacity(0.2))
            }
            
            NavigationLink(destination: AboutUsView()) {
                SettingItemView(iconName: "doc.text.fill", title: "About Us", backgroundColor: Color.yellow.opacity(0.2))
            }
            
            Spacer()
            
            // Logout button with improved layout
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

// About Us View

struct AboutUsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Background decoration
            RoundedRectangle(cornerRadius: 12)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color("primaryMauve").opacity(0.2), Color("secondaryLilac").opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
                .frame(height: 150)
                .overlay(
                    Text("About Us")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color("primaryMauve"))
                        .shadow(radius: 2)
                )
                .padding(.bottom, 16)

            // Description texts
            VStack(alignment: .leading, spacing: 10) {
                Text("TogetherWe is designed to bring people closer by allowing users to share their daily activities and emotions with loved ones. Our goal is to help users maintain meaningful connections, even when physical distance separates them.")
                    .font(.body)
                    .padding()
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(10)
                    .shadow(radius: 2)
                
                Text("With TogetherWe, you can easily document and share your moods and moments, ensuring that your friends and family stay updated on your life. We believe that small moments of empathy and understanding can make a big difference in maintaining strong, supportive relationships.")
                    .font(.body)
                    .padding()
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(10)
                    .shadow(radius: 2)

                Text("TogetherWe—Connecting hearts, bridging distances.")
                    .font(.body)
                    .italic()
                    .padding()
                    .background(Color("primaryMauve").opacity(0.2))
                    .cornerRadius(10)
                    .shadow(radius: 2)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("About Us")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Privacy View
struct PrivacyView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Privacy")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 8)
            
            Text("At TogetherWe, we are committed to protecting your privacy and ensuring that your personal data remains secure. Here’s how we handle your data:")
                .font(.body)
                .padding(.bottom, 4)
            
            Group {
                Text("• Data Encryption: All your data, including mood entries, tasks, and account information, is encrypted to ensure that it stays private and secure.")
                
                Text("• User Control: You have full control over your data. You can manage, update, or delete your personal information directly from the app at any time.")
                
                Text("• No Data Sharing: We do not share your data with third-party services without your explicit consent. Your data is solely used to enhance your experience within the app.")
                
                Text("• Secure Authentication: TogetherWe uses secure authentication methods to protect your account from unauthorized access.")
            }
            .font(.body)
            .padding(.leading, 8)
            .padding(.bottom, 4)
            
            Text("We value your trust and are dedicated to maintaining the confidentiality of your information. If you have any questions or concerns regarding your privacy, please contact us at support@togetherwe.com.")
                .font(.body)
                .padding(.top, 8)
            
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground))
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
    }
}
