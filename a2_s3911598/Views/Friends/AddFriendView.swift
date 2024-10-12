import SwiftUI
import SwiftData

/// The `AddFriendView` struct provides a user interface for adding a new friend.
///
/// This view allows users to enter a friend's name and email, and save the information to the model context. It includes navigation controls for saving or cancelling the action.
struct AddFriendView: View {
    
    /// A binding to control whether the view is presented.
    @Binding var isPresented: Bool
    
    /// The name of the friend to be added.
    @State private var name = ""
    
    /// The email of the friend to be added.
    @State private var email = ""
    
    /// The environment model context used for managing friend data.
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Add a New Friend")
                    .font(.custom("Chalkboard SE", size: 24))
                    .padding([.top, .leading], 16)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Friend Name")
                        .font(.custom("Chalkboard SE", size: 18))
                        .padding(.leading, 10)
                    
                    TextField("Enter name", text: $name)
                        .font(.custom("Chalkboard SE", size: 18))
                        .padding()
                        .background(Color(white: 0.9))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    Text("Friend Email")
                        .font(.custom("Chalkboard SE", size: 18))
                        .padding(.leading, 10)
                    
                    TextField("Enter email", text: $email)
                        .font(.custom("Chalkboard SE", size: 18))
                        .padding()
                        .background(Color(white: 0.9))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .font(.custom("Chalkboard SE", size: 18))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveFriend()
                        isPresented = false
                    }
                    .font(.custom("Chalkboard SE", size: 18))
                }
            }
        }
    }
    
    /// Saves the new friend to the model context.
    ///
    /// This method creates a new `Friend` instance with the entered name and email, and inserts it into the model context.
    private func saveFriend() {
        let newFriend = Friend(name: name, email: email)
        modelContext.insert(newFriend)
    }
}
