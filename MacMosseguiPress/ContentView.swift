//
//  ContentView.swift
//  MacMosseguiPress
//
//  Created by MAC on 29/07/2020.
//  Copyright © 2020 MAC. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var postTitle: String
    @State var mlpAudioURL: String
    @State var documentUrl: String
    @State var imagePath: String
    @State var image: NSImage?
    @State private var userPickedImage: Bool? = false
    @State var mediaIDstate: Int
    var mediaID: Int = -1
    
    @State var alert = false
    @State var alertText = ""
    @State var alertTitle = ""
    
    @State private var selectorIndex = 0
    
    
    func pickFile() {
        let panel = NSOpenPanel()
        panel.prompt = "Seleccionar"
        panel.worksWhenModal = true
        panel.nameFieldStringValue = "hola.jpg"
        panel.canCreateDirectories = false
        panel.canChooseFiles = true
        panel.allowedFileTypes = ["txt", "md"]
        panel.begin { response in
            if response == NSApplication.ModalResponse.OK, let fileUrl = panel.url {
                print(fileUrl)
                self.documentUrl = fileUrl.path
            }
        }
        
    }
    
    func pickImage() {
        let panel = NSOpenPanel()
        panel.isFloatingPanel = false
        panel.nameFieldLabel = "Selecciona la imatge principal:"
        panel.nameFieldStringValue = "hola.jpg"
        panel.canCreateDirectories = false
        panel.canChooseFiles = true
        panel.allowedFileTypes = ["png", "jpeg", "jpg", "gif"]
        panel.begin { response in
            if response == NSApplication.ModalResponse.OK, let fileUrl = panel.url {
                print(fileUrl)
                self.imagePath = fileUrl.path
                self.image = NSImage(byReferencingFile: fileUrl.path)
                self.userPickedImage = true

            }
            else {
                self.userPickedImage = false
            }
        }
    }
    
    func uploadImage() {
        self.image = NSImage(byReferencingFile: self.imagePath)
        if self.image != nil && self.userPickedImage! {
            print("image funca")
            uploadImageMac(image: self.image!, imageTitle: "hola_como_estas", fileName: "hola.png", completion: {
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
        }
    }
    
    var body: some View {
        Form {
            
            Section(header:Text("Títol del Post") ) {
                TextField("El més destacable de la WWDC20 - Programa 420", text: $postTitle)
            }
            Divider()
            Section(header:Text("Arxiu Markdown (Guió)") ) {
                HStack {
                    Button("seleccionar arxiu", action:{
                        self.pickFile()
                    })
                    Text(documentUrl)
                    
                }
            }
            Divider()
            Section(header:Text("Imatge principal") ) {
                HStack {
                    Button("seleccionar imatge", action:{
                        self.pickImage()
                    })
                    Text(imagePath)
                    Button("pujar imatge", action:{
                        self.uploadImage()
                    })
                    
                }
                
            }
            Divider()
            Section(header: Text("Arxiu d'àudio MLP") ) {
                HStack {
                    TextField("https://storagemossegui.com/mlpaudio/mlp445.mp35", text: $mlpAudioURL)
                    Button("Comprovar URL", action:{
                        print("Comprovar URL")
                    })
                }
            }
            Divider()
            Section(header: Text("Estat Post de Wordpress") ) {
                HStack {
                    VStack {
                        Picker("Seleccionar Estat", selection: $selectorIndex) {

                            Text("Esborrany").tag(0)
                            Text("Publicació").tag(1)
                            
                        }
                        .pickerStyle(RadioGroupPickerStyle())
                        .padding()
                    }
                    Button("Pujar Esborrany", action:{
                        print("Comprovar URL")
                    })
                }
            }
            
            
            Text("Hello, World!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(postTitle: "Programa 42", mlpAudioURL: "https://...", documentUrl: "", imagePath: "", mediaIDstate: -1)
    }
}
