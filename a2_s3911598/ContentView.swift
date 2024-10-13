import SwiftUI
import Auth0
import WidgetKit

/// Represents the destinations within the MoodView, specifically for navigating to mood tracking.
enum MoodViewDestination: Hashable {
    case moodTracking
}

/// The `ContentView` struct handles the authentication flow and displays the main content based on the user's authentication state.
///
/// If the user is authenticated, the main content view (`MainTabView`) is displayed. Otherwise, a login/signup interface is shown.
struct ContentView: View {
    
    /// Tracks whether the user is authenticated.
    @State private var isAuthenticated = false
    
    /// Stores the authenticated user's profile information.
    @State var userProfile = Profile.empty

    var body: some View {
        if isAuthenticated {
            // Display the main tab view if authenticated
            MainTabView(userProfile: userProfile, logoutAction: logout)
        } else {
            // Display the login/signup view if not authenticated
            VStack(spacing: 20) {
                Text("Welcome to TogetherWe")
                    .font(.largeTitle)
                    .font(.custom("Chalkboard SE", size: 24))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()

                Button("Login") {
                    login()
                }
                .buttonStyle(MyButtonStyle())

                Button("Signup") {
                    signup()
                }
                .buttonStyle(MyButtonStyle())
            }
            .padding()
        }
    }

    /// Initiates the login flow using Auth0.
    func login() {
        Auth0
            .webAuth()
            .parameters(["screen_hint": "login"])
            .start { result in
                switch result {
                case .failure(let error):
                    print("Failed with: \(error)")
                case .success(let credentials):
                    self.isAuthenticated = true
                    self.userProfile = Profile.from(credentials.idToken)
                }
            }
    }

    /// Initiates the signup flow using Auth0.
    func signup() {
        Auth0
            .webAuth()
            .parameters(["screen_hint": "signup"])
            .start { result in
                switch result {
                case .failure(let error):
                    print("Failed with: \(error)")
                case .success(let credentials):
                    self.isAuthenticated = true
                    self.userProfile = Profile.from(credentials.idToken)
                }
            }
    }

    /// Logs the user out and clears the session.
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

/// The `MainTabView` struct provides the main tab navigation for the app, including mood tracking, tasks, friends, and settings.
///
/// It displays a `TabView` with four tabs, each corresponding to different functionality of the app.
struct MainTabView: View {
    
    /// The user's profile information.
    var userProfile: Profile
    
    /// The action to be performed when the user logs out.
    var logoutAction: () -> Void
    
    /// Manages the presentation of the mood tracking view.
    @State private var isShowingMoodTracking = false
    
    /// The environment's model context for managing data.
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            NavigationView {
                MoodView(userProfile: userProfile)
            }
            .tabItem {
                Label("Moods", systemImage: "face.smiling")
            }
            
            NavigationView {
                DailyTaskView()
            }
            .tabItem {
                Label("Tasks", systemImage: "list.bullet")
            }
            
            NavigationView {
                FriendView()
            }
            .tabItem {
                Label("Friends", systemImage: "person.3.fill")
            }
            
            NavigationView {
                SettingsView(userProfile: userProfile, logoutAction: logoutAction)
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }.onAppear{
            WidgetCenter.shared.reloadTimelines(ofKind: "CurrentTaskWidget")}
    }
}

/// A custom view modifier that applies a bold title style to text elements.
struct TitleStyle: ViewModifier {
    
    /// The font for the title text.
    let titleFontBold = Font.title.weight(.bold)
    
    /// The color used for the title text.
    let navyBlue = Color(red: 0, green: 0, blue: 0.5)

    func body(content: Content) -> some View {
        content
            .font(titleFontBold)
            .foregroundColor(navyBlue)
            .padding()
    }
}

/// A custom button style that applies a navy blue background with scaling when pressed.
struct MyButtonStyle: ButtonStyle {
    
    /// The color used for the button background.
    let navyBlue = Color(red: 0, green: 0, blue: 0.5)

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(navyBlue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
