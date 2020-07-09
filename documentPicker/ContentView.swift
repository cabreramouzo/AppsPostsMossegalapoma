//
//  ContentView.swift
//  documentPicker
//
//  Created by MAC on 06/07/2020.
//  Copyright © 2020 MAC. All rights reserved.
//

import SwiftUI
import MobileCoreServices
import Foundation

struct ContentView: View {
    
    @State var show = false
    
    @State var published:Bool = false
    @State var draft:Bool = true
    
    @State var alert:Bool = false
    
    @State var doc_url:String = ""
    
    @State var doc: FileWrapper?
    @State var showDocumentPicker = false
    @State var inputURL: String?
    
    func toggle_post_options() {
       if published {
           draft = true
           published = false
       }
       else {
           draft = false
           published = true
       }
   }
    
    var body: some View {
        
        NavigationView {
            List() {
                
                Section {

                    Button(action: {
                        self.showDocumentPicker = true
                    }) {
                        HStack {
                            Image(systemName: "rectangle.and.paperclip")
                            Text("Seleccionar arxiu html...")
                        }

                    }
                    .sheet(isPresented: self.$showDocumentPicker, onDismiss: loadDocumentUrl) {
                        DocumentPicker2(doc_url: self.$inputURL)
                    }
                        

                }
                Section {
                    Text("Estat Wordpress").font(.subheadline).foregroundColor(.gray)
                    HStack {
                        Button(action: toggle_post_options) {
                            if draft {
                                Image(systemName: "checkmark.circle")
                            }
                            else {
                                Image(systemName: "circle")
                            }
                            
                        }
                        Text("Esborrany")
                    }
                    HStack {
                        Button(action: toggle_post_options) {
                            if published {
                                Image(systemName: "checkmark.circle")
                            }
                            else {
                                Image(systemName: "circle")
                            }
                            
                        }
                        Text("Publicació")
                    }
                        
                    
                }
                    
                Section {
                    Button(action: {
                        print(self.doc_url)
                        print("FILE URL:")
                        print(self.doc_url)
                        let is_ok = uploadPost(draft: self.draft, documentURL: self.doc_url)
                        //self.alert = uploadPost(draft: self.draft, documentURL: someurl)
                    }) {
                        HStack(alignment: .center) {
                            Spacer()
                            if draft {
                                Image(systemName: "bookmark")
                                Text("Pujar Esborrany")
                            }
                            else {
                                Image(systemName: "text.bubble")
                                Text("Publicar Entrada").accentColor(.red)
                            }
                            Spacer()
                            
                            
                        }.padding(10.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(lineWidth: 2.0)
                        )

                    }.alert(isPresented: $alert) {
                        Alert(title: Text("Carrgat correctament"), message: Text("S'ha carregat"), dismissButton: .default(Text("OK")))
                    }
                    
                }

                
            }.listStyle(GroupedListStyle()).navigationBarTitle("Carregar Post HTML")
        }
    }
    func loadDocumentUrl() {
        guard let inputURL = inputURL else { return }
        doc_url = String(inputURL)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/*

//from https://www.youtube.com/watch?v=q8y_eRVfpMA
struct DocumentPicker : UIViewControllerRepresentable {
    
    func makeCoordinator() ->DocumentPicker.Coordinator {
        return DocumentPicker.Coordinator(parent1: self)
    }
    
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        
        let picker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeHTML)], in: .open)
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
        
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        
        var parent: DocumentPicker
        
        init(parent1: DocumentPicker) {
            parent = parent1
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            let path = urls.first!.absoluteString
            
            
        }
    }
}
*/
