import SwiftUI
import UIKit

/// The `ImagePickerCoordinator` struct is a SwiftUI wrapper for the UIKit `UIImagePickerController` that allows users to select images from their photo library.
///
/// It uses the `UIViewControllerRepresentable` protocol to integrate `UIImagePickerController` with SwiftUI.
/// This view is designed to work with an observable view model `ImagePickerViewModel`, which manages the selected image.
struct ImagePickerCoordinator: UIViewControllerRepresentable {
    
    /// The view model that manages the selected image.
    @ObservedObject var viewModel: ImagePickerViewModel
    
    /// Dismisses the image picker when the user finishes selecting or cancels.
    @Environment(\.dismiss) private var dismiss

    /// Creates the `UIImagePickerController` instance.
    ///
    /// - Parameter context: The context in which the view controller is created.
    /// - Returns: A configured `UIImagePickerController` instance.
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    /// Updates the view controller.
    ///
    /// This method is required by `UIViewControllerRepresentable` but is not used in this implementation.
    ///
    /// - Parameters:
    ///   - uiViewController: The `UIImagePickerController` instance.
    ///   - context: The context in which the view controller is updated.
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    /// Creates the `Coordinator` instance that acts as the delegate for `UIImagePickerController`.
    ///
    /// - Returns: A `Coordinator` instance.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    /// The `Coordinator` class acts as the delegate for the `UIImagePickerController`, handling user interactions such as selecting or canceling the image picker.
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        /// The parent `ImagePickerCoordinator` instance.
        var parent: ImagePickerCoordinator

        /// Initializes the coordinator with a reference to the parent `ImagePickerCoordinator`.
        ///
        /// - Parameter parent: The parent `ImagePickerCoordinator` instance.
        init(_ parent: ImagePickerCoordinator) {
            self.parent = parent
        }

        /// Called when the user selects an image from the photo library.
        ///
        /// If the user successfully picks an image, this method updates the view model with the selected image.
        ///
        /// - Parameters:
        ///   - picker: The `UIImagePickerController` instance.
        ///   - info: A dictionary containing the media info of the picked image. The selected image can be accessed with the `.originalImage` key.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.viewModel.setImage(image)
            }
            parent.dismiss()
        }

        /// Called when the user cancels the image picking process.
        ///
        /// This method dismisses the image picker when the user decides not to pick an image.
        ///
        /// - Parameter picker: The `UIImagePickerController` instance.
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
