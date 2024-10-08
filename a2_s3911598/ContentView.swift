import SwiftUI
import Auth0

// 代表 MoodView 的枚举
enum MoodViewDestination: Hashable {
    case moodTracking
}

// 合并后的 ContentView
struct ContentView: View {
    @State private var isAuthenticated = false
    @State var userProfile = Profile.empty
    
    var body: some View {
        if isAuthenticated {
            // 显示主 TabView 页面
            MainTabView(userProfile: userProfile, logoutAction: logout)
        } else {
            // 未登录时显示登录页面
            VStack {
                Text("SwiftUI Login Demo")
                    .modifier(TitleStyle())
                
                Button("Log in") {
                    login()
                }
                .buttonStyle(MyButtonStyle())
            }
        }
    }
    
    func login() {
        Auth0
            .webAuth()
            .start { result in
                switch result {
                case .failure(let error):
                    print("Failed with: \(error)")
                case .success(let credentials):
                    self.isAuthenticated = true
                    self.userProfile = Profile.from(credentials.idToken)
                    print("Credentials: \(credentials)")
                    print("ID token: \(credentials.idToken)")
                }
            }
    }
    
    func logout() {
        Auth0
            .webAuth()
            .clearSession { result in
                switch result {
                case .success:
                    self.isAuthenticated = false
                    self.userProfile = Profile.empty
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            }
    }
}

// 主 TabView，用户登录后显示
struct MainTabView: View {
    var userProfile: Profile
    var logoutAction: () -> Void
    
    @State private var isShowingMoodTracking = false
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        
        TabView {
            NavigationView {
                DailyTaskView()
                    .navigationBarItems(trailing: HStack {
                        Text("Welcome, \(userProfile.name)")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        Button("Logout", action: logoutAction)
                            .padding(8)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    })
            }
            .tabItem {
                Label("Tasks", systemImage: "list.bullet")
            }
            
            NavigationView {
                MoodView()
            }
            .tabItem {
                Label("Moods", systemImage: "face.smiling")
            }
            
            NavigationView {
                FriendView()
                    .navigationTitle("Friends")
            }
            .tabItem {
                Label("Friends", systemImage: "person.3.fill")
            }
            
            NavigationView {
                            SettingsView(userProfile: userProfile, logoutAction: logoutAction) // 修改为 SettingsView
                                .navigationTitle("Settings")
                        }
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
        }
    }
}


//struct SettingView: View {
//    var body: some View {
//        Text("Settings Content")
//            .navigationTitle("Settings")
//    }
//}

// 自定义 ViewModifier 和 ButtonStyle
struct TitleStyle: ViewModifier {
    let titleFontBold = Font.title.weight(.bold)
    let navyBlue = Color(red: 0, green: 0, blue: 0.5)
    
    func body(content: Content) -> some View {
        content
            .font(titleFontBold)
            .foregroundColor(navyBlue)
            .padding()
    }
}

struct MyButtonStyle: ButtonStyle {
    let navyBlue = Color(red: 0, green: 0, blue: 0.5)
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(navyBlue)
            .foregroundColor(.white)
            .clipShape(Capsule())
    }
}

// ContentView 的预览
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
