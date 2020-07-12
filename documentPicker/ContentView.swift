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
    @State var sucessUpload: Bool = false

    @State var showDocumentPicker = false
    @State var inputURL: URL?
    
    var is_ok = false
    @State var alertText = "Hi ha hagut un error al pujar l'arxiu a Wordpress"
    @State var alertTitle = "⚠️ Error!"
    
    @State var userPickedDocument:Bool? = false
    
    @State private var showActivityIndicator: Bool = false
    
    
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
                        self.userPickedDocument = true
                    }) {
                        HStack {
                            Image(systemName: "rectangle.and.paperclip")
                            if self.inputURL != nil {
                                Text(self.inputURL!.path)
                            }
                            else {
                                Text("Seleccionar arxiu html...")
                            }
                        }
                    }
                    .sheet(isPresented: self.$showDocumentPicker) {
                        DocumentPicker2(docURL: self.$inputURL, userPickedDocument: self.$userPickedDocument)
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
                        print("FILE URL:")
                        print(self.inputURL as Any)
                        self.showActivityIndicator = true
                        
                        uploadPost(draft: self.draft, documentURL: self.inputURL!, completion: { (is_ok) -> Void in
                            self.alert = true
                            print("es ok")
                            print(is_ok)
                            if is_ok {
                                self.alertText = "Arxiu carregat correctament!"
                                self.alertTitle = "✅ OK"
                            }
                            else {
                                self.alertText = "Hi ha hagut un error al pujar l'arxiu a Wordpress"
                                self.alertTitle = "⚠️ Error!"
                            }
                            
                        })
                            
                        // Make sure you release the security-scoped resource when you are done.
                        do { self.inputURL!.stopAccessingSecurityScopedResource() }

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
                            if showActivityIndicator == true {
                                ActivityIndicator()
                                .frame(width: 20, height: 20)
                            }
                            
                            Spacer()
                            
                        }.padding(10.0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10.0)
                                .stroke(lineWidth: 2.0)
                        )

                    }.alert(isPresented: $alert) {
                        return Alert(title: Text(alertTitle), message: Text(alertText), dismissButton: .default(Text("Ok!")) {self.showActivityIndicator = false})
                    }
                    .disabled(!userPickedDocument!)
                }
                
            }.listStyle(GroupedListStyle()).navigationBarTitle("Carregar Post HTML")
        }
    }
}

/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}*/
