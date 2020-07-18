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
    
    @State var postTitle: String
    
    var is_ok = false
    @State var alertText = "Hi ha hagut un error al pujar l'arxiu a Wordpress"
    @State var alertTitle = "⚠️ Error!"
    
    @State var userPickedDocument:Bool? = false
    
    @State private var showActivityIndicator: Bool = false
    
    @State private var image: Image?
    @State  var imageFileName: String
    @State  var imageTitle: String
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var userPickedImage: Bool? = false
    @State var mediaIDstate: Int
    var mediaID: Int = -1
    
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
    
    func loadImage() {
        print("loadimage")
        guard let inputImage = inputImage else {return}
        image = Image(uiImage: inputImage)
    }
    
    
    
    var body: some View {
        
        
        NavigationView {
            Form {
                Section(header: Text("Títol del post").bold()) {
                    TextField("El més destacable de la WWDC20 - Programa 420", text: $postTitle)
                }
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
                Section(header: Text("Imatge principal").bold()) {

                    TextField("Crisi de confiança", text: $imageTitle)
                    TextField("crisi_de_confiança.png", text: $imageFileName)
                    ZStack {
                        Rectangle().fill(Color.secondary)
                        
                        if image != nil {
                            image?
                            .resizable()
                            .scaledToFit()                        }
                        else {
                            Text("Prémer aquí per triar una imatge")
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                    }
                    .onTapGesture {
                        self.showImagePicker = true
                    }
                    .sheet(isPresented: self.$showImagePicker, onDismiss: loadImage) {
                        ImagePicker(image: self.$inputImage, userPickedImage: self.$userPickedImage)
                    }
                }
                Section {
                    Button(action: {
                        self.showActivityIndicator = true
                        self.userPickedImage = true
                        uploadImage(image: self.inputImage!, imageTitle: self.imageTitle, fileName: self.imageFileName, completion: {
                            (is_ok, mediaID) -> Void in
                            self.alert = true
                            print("es ok")
                            print(is_ok)
                            print("mediaID")
                            print(mediaID)
                            self.mediaIDstate = mediaID
                            if is_ok {
                                self.alertText = "Imatge carregada correctament!"
                                self.alertTitle = "✅ OK"
                            }
                            else {
                                self.alertText = "Hi ha hagut un error al pujar l'imatge a Wordpress"
                                self.alertTitle = "⚠️ Error!"
                            }
                        })
                        
                        }) {
                        HStack(alignment: .center) {
                            Spacer()

                            Image(systemName: "bookmark")
                            Text("Pujar Imatge")

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
                    .disabled(!userPickedImage!)
                }
                Section(header: Text("Estat Wordpress").bold(), footer: Text("Abans de pujar el post, puja la imatge destacada") ) {
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
                        
                        
                        uploadPost(draft: self.draft, title: self.postTitle , documentURL: self.inputURL!, mediaID: self.mediaIDstate,  completion: { (is_ok) -> Void in
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
