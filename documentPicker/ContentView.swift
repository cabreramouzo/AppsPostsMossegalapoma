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
    
    @State var docURL:URL

    @State var showDocumentPicker = false
    @State var inputURL: URL?
    
    var is_ok = false
    @State var alertText = "Hi ha hagut un error al pujar l'arxiu a Wordpress"
    
    @State var userPickedDocument:Bool? = false
    
    @State private var isAnimating: Bool = false
    
    
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
                    .sheet(isPresented: self.$showDocumentPicker, onDismiss: loadDocumentUrl) {
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
                        print(self.docURL)
                        self.isAnimating = true
                        
                        uploadPost(draft: self.draft, documentURL: self.docURL, completion: { (is_ok) -> Void in
                            self.alert = true
                            print("es ok")
                            print(is_ok)
                            if is_ok {
                                self.alertText = "Arxiu carregat correctament!"
                            }
                            
                        })
                            
                        // Make sure you release the security-scoped resource when you are done.
                        do { self.docURL.stopAccessingSecurityScopedResource() }

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
                            if isAnimating == true {
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
                        return Alert(title: Text("Alerta!"), message: Text(alertText), dismissButton: .default(Text("Ok!")) {self.isAnimating = false})
                    }
                    .disabled(!userPickedDocument!)
                }
                
            }.listStyle(GroupedListStyle()).navigationBarTitle("Carregar Post HTML")
        }
    }
    func loadDocumentUrl() {
        print ("loadDocument---")
        guard let inputURL = inputURL else { return }
        docURL = inputURL
        isAnimating = false
    }
}

/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}*/

struct ActivityIndicator: View {

  @State private var isAnimating: Bool = false

  var body: some View {
    GeometryReader { (geometry: GeometryProxy) in
      ForEach(0..<5) { index in
        Group {
          Circle()
            .frame(width: geometry.size.width / 5, height: geometry.size.height / 5)
            .scaleEffect(!self.isAnimating ? 1 - CGFloat(index) / 5 : 0.2 + CGFloat(index) / 5)
            .offset(y: geometry.size.width / 10 - geometry.size.height / 2)
          }.frame(width: geometry.size.width, height: geometry.size.height)
            .rotationEffect(!self.isAnimating ? .degrees(0) : .degrees(360))
            .animation(Animation
              .timingCurve(0.5, 0.15 + Double(index) / 5, 0.25, 1, duration: 1.5)
              .repeatForever(autoreverses: false))
        }
      }
    .aspectRatio(1, contentMode: .fit)
    .onAppear {
        self.isAnimating = true
    }
  }
}
