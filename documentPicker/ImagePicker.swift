//
//  audioPicker.swift
//  documentPicker
//
//  Created by MAC on 16/07/2020.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation
import SwiftUI
import MobileCoreServices

struct ImagePicker: UIViewControllerRepresentable {
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let parent: ImagePicker
    
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if info[.cropRect] != nil {
                if let uiImage = info[.cropRect] as? UIImage {
                    parent.image = uiImage
                    parent.userPickedImage = true
                }
            }
            else {
                if let uiImage = info[.originalImage] as? UIImage {
                    parent.image = uiImage
                    parent.userPickedImage = true
                }
            }
                        
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    @Binding var image: UIImage?
    @Binding var userPickedImage: Bool?
    @Environment(\.presentationMode) var presentationMode
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
}
