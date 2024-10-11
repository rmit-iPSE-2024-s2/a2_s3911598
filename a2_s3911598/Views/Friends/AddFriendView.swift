import SwiftUI
import SwiftData

struct AddFriendView: View {
    @Binding var isPresented: Bool

    @State private var name = ""
    @State private var email = ""

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

    private func saveFriend() {
        let newFriend = Friend(name: name, email: email)
        modelContext.insert(newFriend)  
    }
}
