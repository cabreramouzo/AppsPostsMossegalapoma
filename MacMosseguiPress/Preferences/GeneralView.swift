//
//  Preferences.swift
//  MacMosseguiPress
//
//  Created by MAC on 03/08/2020.
//  Copyright © 2020 MAC. All rights reserved.
//

import SwiftUI
import Preferences

/**
Function wrapping SwiftUI into `PreferencePane`, which is mimicking view controller's default construction syntax.
*/
let GeneralViewController: () -> PreferencePane = {
    /// Wrap your custom view into `Preferences.Pane`, while providing necessary toolbar info.
    let paneView = Preferences.Pane(
        identifier: .general,
        title: "General",
        toolbarIcon: NSImage(named: NSImage.preferencesGeneralName)!
    ) {
        GeneralView(settings: SettingsMac(), categories: [
        WordpressCategory(wordpressId: "28", name: "Apple", Postdefault: true),
        WordpressCategory(wordpressId: "24", name: "Podcast", Postdefault: false),
        WordpressCategory(wordpressId: "3", name: "Mac", Postdefault: true),
        WordpressCategory(wordpressId: "34", name: "iPhone", Postdefault: true),
        WordpressCategory(wordpressId: "12", name: "Opinió", Postdefault: false)])

    }

    return Preferences.PaneHostingController(pane: paneView)
}


struct GeneralView: View {
    
    var settings: SettingsMac
    
    @State private var urlPost:String = "localhost/posts"
    @State private var urlMedia:String = "localhost/media"
    @State private var urlAudio:String = "localhost/mlpaudio"
    @State private var authorId:String = "1"
    @State private var user:String = "macma"
    @State private var password:String = "1234"
    @State private var defaultIndexRadioButton:Int = 0
    
    private let contentWidth: Double = 600.0
    
    @State var categories:[WordpressCategory]
    
    //TODO como saber size a partir de settings?
    @State private var toggles:[Bool] = [false, false, false, true, true]
    
    
    func saveCategories() {
        for i in self.toggles.indices {
            categories[i].postDefault = self.toggles[i]
        }
        settings.cats = categories
    }
    
    func loadCategories() {
        categories = settings.cats
        
        for index in categories.indices {
            toggles[index] = (categories[index].postDefault)
        }
        print("he rellenado los toggles")
    }
    
    var body: some View {
        
        Preferences.Container(contentWidth: contentWidth) {
            Preferences.Section(title: "URL Servidor Post:") {
                TextField("https://mossegalapoma.cat/wp-json/wp/v2/posts", text: self.$urlPost)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 420.0)
                Text("URL per penjar els posts sense '/' final")
                .preferenceDescription()

            }
            Preferences.Section(title: "URL Servidor Media:") {
                TextField("https://mossegalapoma.cat/wp-json/wp/v2/media", text: self.$urlMedia)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 420.0)
                Text("URL per penjar la mèdia (foto entrada) sense '/' final")
                    .preferenceDescription()

            }
            Preferences.Section(title: "URL Audio:") {
                TextField("https://storagemossegui.com/mlpaudio/mlp4", text: self.$urlAudio)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 420.0)
                Text("URL per penjar l'àudio")
                    .preferenceDescription()

            }
            
            Preferences.Section(title: "Credencials d'aquesta App:") {
                
                TextField("Usuari:", text: self.$user)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 420.0)
                SecureField("Contrassenya:", text: self.$password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 420.0)

            }

            Preferences.Section(title: "Autor per defecte:") {
                Picker("", selection: self.$authorId) {
                    Text("tomasmanz").tag("1")
                    Text("Ludo").tag("2")
                    Text("macma").tag("18")
                    Text("wolffan").tag("5")
                }
                    .labelsHidden()
                    .frame(width: 120.0)
                Text("S'usarà tant als posts com al mèdia")
                    .preferenceDescription()
            }
            
            Preferences.Section(title: "Tipus de post per omisió:") {
                
                Picker("", selection: self.$defaultIndexRadioButton) {
                    Text("Publicació").tag(0)
                    Text("Esborrany").tag(1)
                }
                .labelsHidden()
                .frame(width: 120.0)
            }
            
            Preferences.Section(title: "Categories per omisió:") {

                HStack {
                    ForEach (self.categories.indices) { i in
                        HStack {
                            Toggle(self.categories[i].name, isOn: self.$toggles[i])
                        }
                        
                    }
                    
                }
                
            }
            
            
            Preferences.Section(title: "") {
                Button(action: {
                    self.settings.postServer = self.urlPost
                    self.settings.mediaServer = self.urlMedia
                    self.settings.audioUrl = self.urlAudio
                    self.settings.authorId = self.authorId
                    self.settings.user = self.user
                    self.settings.password = self.password
                    self.settings.defaultIndexRadioButton = self.defaultIndexRadioButton
                    self.saveCategories()
                    print("save categories")
                    print(self.categories)
                    print(self.settings.cats)
                    
                }) {
                    Text("Aplicar canvis")
 
                }
    
            }
        }.onAppear {
            self.urlPost = self.settings.postServer
            self.urlMedia = self.settings.mediaServer
            self.urlAudio = self.settings.audioUrl
            self.authorId = self.settings.authorId
            self.user = self.settings.user
            self.password = self.settings.password
            self.defaultIndexRadioButton = self.settings.defaultIndexRadioButton
            self.loadCategories()
        }
    }
}

struct GeneralView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralView(settings: SettingsMac(), categories: [WordpressCategory(wordpressId: "qqq", name: "qqq", Postdefault: true)] )
    }
}
