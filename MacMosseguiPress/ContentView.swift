//
//  ContentView.swift
//  MacMosseguiPress
//
//  Created by MAC on 29/07/2020.
//  Copyright © 2020 MAC. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    let settings = SettingsMac()
    @State var postTitle: String
    @State var mlpAudioURL: String
    @State var inputURL: URL?
    @State var imagePath: String
    @State var image: NSImage?
    @State private var userPickedImage: Bool = false
    @State var mediaIDstate: Int
    var mediaID: Int = -1
    @State var imageTitle:String = ""
    @State var imageAlternativeText: String = ""
    @State var imageUploaded = false
    
    @State var ShowAlertImage = false
    @State var ShowAlertPost = false
    @State var alertText = ""
    @State var alertTitle = ""
    
    @State var selectorIndex: Int = 0
    
    @State var draft:Bool = true
    
    @State var url_ok:Bool? = false
    @State var url_ok_message:String = ""
    
    @State private var showActivityIndicatorImageButton: Bool = false
    @State private var showActivityIndicatorURLButton: Bool = false
    @State private var showActivityIndicatorPostButton: Bool = false
    
    //categories toggles
    @State private var catToggles = [Bool](repeating: true, count: 5)
    
    func loadCategories() {
        let numCats = settings.categories.count
        
        for index in settings.categories.indices {
            catToggles[index] = (settings.categories[index].postDefault)
        }
        
    }
    
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
                self.inputURL = fileUrl
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
                self.imagePath = ""
            }
        }
    }
    
    func uploadImage() {
        self.image = NSImage(byReferencingFile: self.imagePath)
        if self.image != nil && self.userPickedImage {
            print("image funca")
            uploadImageMac(image: self.image!, imageTitle: self.imageTitle, imageAlternativetext: self.imageAlternativeText, completion: {
                (is_ok, mediaID) -> Void in
                print("es ok")
                print(is_ok)
                print("mediaID")
                print(mediaID)
                self.mediaIDstate = mediaID
                if is_ok {
                    self.alertText = "Imatge carregada correctament!"
                    self.alertTitle = "✅ OK"
                    self.imageUploaded = true
                }
                else {
                    self.alertText = "Hi ha hagut un error al pujar l'imatge a Wordpress"
                    self.alertTitle = "⚠️ Error!"
                }
                self.ShowAlertImage = true
            })
        }
    }
    
    var body: some View {
        Form {
            Group {
                
                Section(header:Text("Títol del Post") ) {
                    HStack {
                        TextField("El més destacable de la WWDC20 - Programa 420", text: $postTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Spacer()
                    }
                    
                }
                Divider()
                Section(header:Text("Arxiu Markdown (Guió)") ) {
                    HStack {
                        Button("seleccionar arxiu", action:{
                            self.pickFile()
                        })
                        if inputURL != nil {
                            Text(inputURL!.path)
                        }
                        
                        
                    }
                }
            }
            
            Divider()
            Section(header:Text("Imatge principal"), footer: Text("Abans de publicar, puja la imatge.") ) {
                VStack {
                    HStack {
                        TextField("Títol: Crisi de confiança", text: $imageTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Spacer()
                    }
                    HStack {
                        TextField("Text Alternatiu: Cel vermell amb núvols", text: $imageAlternativeText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Spacer()
                    }
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Button("seleccionar imatge", action:{
                                self.pickImage()
                            })
                            Text(imagePath)
                            Spacer()
                        }
                        
                        Button("Pujar Imatge", action:{
                            self.uploadImage()
                        }).alert(isPresented: $ShowAlertImage) {
                            Alert(title: Text(alertTitle), message: Text(alertText), dismissButton: .default(Text("Ok!")))
                        }
                        .disabled(!self.userPickedImage)
                        Spacer()
                    }
                    
                    Spacer()
                }
                
                
            }
            Divider()
            Section(header: Text(url_ok_message + " Arxiu d'àudio MLP " + url_ok_message) ) {
                HStack {
                    TextField("https://storagemossegui.com/mlpaudio/mlp445.mp3", text: $mlpAudioURL, onCommit: {
                        self.showActivityIndicatorURLButton = true
                        checkURL(url: self.mlpAudioURL, completion: { (url_ok) -> Void in
                            
                            if url_ok {
                                self.alertText = "URL accessible"
                                self.alertTitle = "✅ OK"
                                
                                self.url_ok_message = "✅"
                                
                            }
                            else {
                                self.alertText = "URL no accessible"
                                self.alertTitle = "⚠️ Error!"
                                
                                self.url_ok_message = "⚠️"
                                print("no url")
                            }
                            
                            self.showActivityIndicatorURLButton = false
                        })
                        
                    }).textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    //.textCase(.lowercase) is beta for 11.0
                    
                    
                    
                    Button(action:{
                        self.showActivityIndicatorURLButton = true
                        checkURL(url: self.mlpAudioURL, completion: { (url_ok) -> Void in
                            
                            if url_ok {
                                self.alertText = "URL accessible"
                                self.alertTitle = "✅ OK"
                                
                                self.url_ok_message = "✅"
                                
                            }
                            else {
                                self.alertText = "URL no accessible"
                                self.alertTitle = "⚠️ Error!"
                                
                                self.url_ok_message = "⚠️"
                                print("no url")
                            }
                            self.showActivityIndicatorURLButton = false
                            
                            
                        })
                    }) {
                        
                        HStack(alignment: .center) {
                            Spacer()
                            Text("Comprovar URL")
                            if showActivityIndicatorURLButton == true {
                                ActivityIndicator()
                                    .frame(width: 20, height: 20)
                            }
                            Spacer()
                        }
                    }.disabled(self.mlpAudioURL == "")
                    Spacer()
                }
            }
            Divider()
            Section(header: Text("Estat Post de Wordpress") ) {
                HStack {
                    VStack {
                        Picker("", selection: self.$selectorIndex) {
                            
                            Text("Publicació").tag(0)
                            Text("Esborrany").tag(1)
                            
                        }
                        .pickerStyle(RadioGroupPickerStyle())
                        .padding()
                    }
                    Button("Pujar Post", action:{
                        
                        if self.selectorIndex == 0 {
                            self.draft = false
                        }
                        else if self.selectorIndex == 1 {
                            self.draft = true
                        }
                        
                        var catsIds = [Int]()
                        for index in self.settings.categories.indices {
                            if self.catToggles[index] {
                                catsIds.append( Int(self.settings.categories[index].id)! )
                            }
                        }
                        
                        uploadPost(draft: self.draft, title: self.postTitle , documentURL: self.inputURL!, audioURL: self.mlpAudioURL, mediaID: self.mediaIDstate, categories: catsIds,  completion: { (is_ok) -> Void in
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
                            self.ShowAlertPost = true
                            
                        })
                    }).alert(isPresented: $ShowAlertPost) {
                        Alert(title: Text(alertTitle), message: Text(alertText), dismissButton: .default(Text("Ok!")) {print("activity indicator")})
                    }.disabled(postTitle == "" || inputURL == nil || imageUploaded == false)
                }
            }
            Group {
                Divider()
                Section(header: Text("Categories Post") ) {
                    HStack {
                        ForEach (settings.categories.indices) { i in
                            HStack {
                                Toggle(self.settings.categories[i].name, isOn: self.$catToggles[i])
                            }
                            
                        }
                        
                    }
                }
                
            }
            
            Divider()
            Text("Hello Mossegui!")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }.onAppear {
            self.selectorIndex = self.settings.defaultIndexRadioButton
            self.loadCategories()
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(postTitle: "Programa 42", mlpAudioURL: "https://...", inputURL: URL(string: ""), imagePath: "", mediaIDstate: -1)
    }
}

