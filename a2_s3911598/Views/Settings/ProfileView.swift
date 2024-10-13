import SwiftUI

/// The `ProfileView` struct provides a user interface for updating the username.
///
/// This view allows users to input a new username, save it to `UserDefaults`, and displays a confirmation alert upon successful save.
struct ProfileView: View {
    /// The username that is being updated and saved by the user. It is a binding property so changes can reflect across views.
    @Binding var username: String
    
    /// A state variable to control the display of the success alert.
    @State private var showAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Profile title
            Text("Profile")
                .font(.system(size: 34, weight: .bold))
                .padding(.top, 40)
                .padding(.bottom, 20)

            // Username input field
            Text("Username")
                .font(.headline)
                .foregroundColor(.primary)

            // Text field for entering the username
            TextField("Enter your username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            // Save button to save the username
            Button(action: {
                saveUsername()  // Save username to UserDefaults
                showAlert = true // Show success alert
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
                // Alert displayed when the username is successfully saved
                Alert(title: Text("Success"), message: Text("Your username has been saved!"), dismissButton: .default(Text("OK")))
            }

            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
    }

    /// Saves the updated username to `UserDefaults`.
    func saveUsername() {
        UserDefaults.standard.set(username, forKey: "username")
        print("Username saved: \(username)")
    }
}
