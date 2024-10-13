import UIKit
import SwiftUI

/// The `ImagePickerViewModel` class is an observable view model that manages the image selection process.
///
/// This class is used in combination with the `ImagePickerCoordinator` to handle the user's image selection from the photo library. It stores the selected image and provides methods to set or clear the image.
class ImagePickerViewModel: ObservableObject {

    /// The selected image from the photo library.
    ///
    /// This property is updated when the user selects an image and can be cleared if necessary.
    @Published var selectedImage: UIImage?

    /// Updates the view model with the provided image.
    ///
    /// This method is called when the user selects an image from the photo library.
    ///
    /// - Parameter image: The image selected by the user.
    func setImage(_ image: UIImage?) {
        self.selectedImage = image
    }

    /// Clears the currently selected image.
    ///
    /// This method is used to remove the selected image from the view model, resetting the state.
    func clearImage() {
        self.selectedImage = nil
    }
}


