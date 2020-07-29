//
//  documentPicker.swift
//  documentPicker
//
//  Created by MAC on 09/07/2020.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation
import SwiftUI
import MobileCoreServices

struct DocumentPicker2: UIViewControllerRepresentable {
    
    @Binding var docURL: URL?
    @Binding var userPickedDocument: Bool?
    @Environment(\.presentationMode) var presentationMode
    
    class Coordinator:NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate  {
        
        var parent: DocumentPicker2
        
        
        init(_ parent: DocumentPicker2) {
            self.parent = parent
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            if parent.docURL == nil {
                parent.userPickedDocument = false
            }
            
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            
            // Start accessing a security-scoped resource.
            guard urls.first!.startAccessingSecurityScopedResource() else {
                // Handle the failure here.
                return
            }
            
            parent.docURL = urls.first!
            print("fist url")
            print(urls.first!)
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(documentTypes: [kUTTypeHTML as String, kUTTypeText as String], in: .open)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        
        
    }
    
    
}

