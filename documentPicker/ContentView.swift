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
    
    @State var docURL:URL

    @State var showDocumentPicker = false
    @State var inputURL: URL?
    
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
                        DocumentPicker2(docURL: self.$inputURL)
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
                        print(self.docURL)
                        
                        let is_ok = uploadPost(draft: self.draft, documentURL: self.docURL)
                        
                        // Make sure you release the security-scoped resource when you are done.
                        do { self.docURL.stopAccessingSecurityScopedResource() }
                        
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
        docURL = inputURL
    }
}

/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}*/
