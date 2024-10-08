//
//  ImagePicker.swift
//  a2_s3911598
//
//  Created by lea Wang on 7/10/2024.
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(parent: ImagePicker) {
            self.parent = parent
        }

        // Called when the user picks an image.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            // Retrieve the selected image.
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }

            // Dismiss the picker.
            parent.dismiss()
        }

        // Called when the user cancels the picker.
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // Dismiss the picker.
            parent.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    // Create the UIImagePickerController.
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator

        // Configure picker settings (e.g., allow editing, source type).
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No updates needed.
    }
}

