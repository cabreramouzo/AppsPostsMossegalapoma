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
        GeneralView(settings: SettingsMac())
    }

    return Preferences.PaneHostingController(pane: paneView)
}


struct GeneralView: View {
    
    var settings: SettingsMac
    
    @State private var urlPost:String = "localhost/posts"
    @State private var urlMedia:String = "localhost/media"
    @State private var authorId:String = "1"
    @State private var user:String = "macma"
    @State private var password:String = "1234"
    @State private var defaultIndexRadioButton:Int = 0

    private let contentWidth: Double = 600.0
    
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
            
            Preferences.Section(title: "") {
                Button(action: {
                    self.settings.postServer = self.urlPost
                    self.settings.mediaServer = self.urlMedia
                    self.settings.authorId = self.authorId
                    self.settings.user = self.user
                    self.settings.password = self.password
                    self.settings.defaultIndexRadioButton = self.defaultIndexRadioButton
                }) {
                    Text("Aplicar canvis")
 
                }
    
            }
        }.onAppear {
            self.urlPost = self.settings.postServer
            self.urlMedia = self.settings.mediaServer
            self.authorId = self.settings.authorId
            self.user = self.settings.user
            self.password = self.settings.password
            self.defaultIndexRadioButton = self.settings.defaultIndexRadioButton
        }
    }
}

struct GeneralView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralView(settings: SettingsMac())
    }
}
