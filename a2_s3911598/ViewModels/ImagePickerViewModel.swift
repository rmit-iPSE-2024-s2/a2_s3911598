import UIKit
import SwiftUI

class ImagePickerViewModel: ObservableObject {
    @Published var selectedImage: UIImage?

    func setImage(_ image: UIImage?) {
        self.selectedImage = image
    }

    func clearImage() {
        self.selectedImage = nil
    }
}

