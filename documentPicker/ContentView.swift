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


func uploadPost() -> Void {
    
    let user = "publisher"
    let psw = "XbIb 8kS6 31Xw 2szM xVmd 58JK"
    let credentials = user + ":" + psw

    let token = credentials.data(using: String.Encoding.utf8)?.base64EncodedString()
    //Data is a byte buffer
    let decodedToken = Data(base64Encoded: token!)!
    
    //read html file
    let file = "" //this is the file. we will write to and read from it
    var html_content = ""
    if let filepath = Bundle.main.path(forResource: "programa_tipic_nomes_body.html", ofType: "html") {
        do {
            let contents = try String(contentsOfFile: filepath)
            print(contents)
            html_content = contents
            
        } catch {
            // contents could not be loaded
        }
    } else {
        // example.txt not found!
        print("No existe")
    }
    html_content = "<strong>Amb la col·laboració de la <a href=\"https://www.upc.edu/ca\">Universitat Politècnica de Catalunya</a>.</strong>"


    let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first

    //let fileURL = dir!.appendingPathComponent(file)

    //reading

    //let html_content = try! String(contentsOf: fileURL, encoding: .utf8)

    let url_srcdest = URL(string: "http://192.168.1.128/wp-json/wp/v2/posts")
    guard let requestUrl = url_srcdest else { fatalError() }
    
    
    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"
    
    // Set HTTP Request Header
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Basic " + token!, forHTTPHeaderField: "Authorization")
    
    //print(String(data: decodedToken, encoding: .utf8)!)

    // Set HTTP Request Body
    let json: [String: Any] = ["title": "CACA",
    "content": html_content,
    "status": "draft",
    "comment_status" : "open"]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    //request.httpBody = postString.data(using: String.Encoding.utf8);
    request.httpBody = jsonData
    
    
    
    
    // Perform HTTP Request
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }
     
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response data string:\n \(dataString)")
                              
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("statusCode: \(httpResponse.statusCode)")
            }
                    
    }
    task.resume()
}




struct ContentView: View {
    
    @State var show = false
    
    var body: some View {
        
        VStack {
            Button(action: {
                self.show.toggle()
            }) {
                Text("Seleccionar arxiu")
            }
            .sheet(isPresented: $show) {
                DocumentPicker()
            }
            Button(action:{
                print("començo a carregar")
                uploadPost()}) {
                Text("carregar post")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
//from https://www.youtube.com/watch?v=q8y_eRVfpMA
struct DocumentPicker : UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
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
             print(urls)
        }
    }
}
