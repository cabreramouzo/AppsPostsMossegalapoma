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
    
    @State private var selectorIndex = 0
    
    var body: some View {
        Form {
            
            Section(header:Text("Títol del Post") ) {
                TextField("El més destacable de la WWDC20 - Programa 420", text: $postTitle)
            }
            Divider()
            Section(header:Text("Arxiu Markdown (Guió)") ) {
                HStack {
                    Button("seleccionar arxiu", action:{
                        print("hola")
                        let a = "hola"
                    })
                    Text("Ruta: /Users/macma/documents/...")
                    
                }
            }
            Divider()
            Section(header:Text("Imatge proncipal") ) {
                HStack {
                    Button("seleccionar imatge", action:{
                        print("hola")
                        let a = "hola"
                    })
                    Text("Ruta: /Users/macma/documents/...")
                    Button("Pujar imatge", action:{
                        print("pujar imatge")
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
        ContentView(postTitle: "Programa 42", mlpAudioURL: "https://...")
    }
}
