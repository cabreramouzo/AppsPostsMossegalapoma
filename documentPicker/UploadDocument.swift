//
//  UploadDocument.swift
//  documentPicker
//
//  Created by MAC on 09/07/2020.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation


func extractStringFromHTMLDocument(htmlDocURL:String) -> String {
    
    let path = htmlDocURL
    var fileContent: String = ""
    let fm = FileManager.default
    var baseURL = NSURL(fileURLWithPath: "file:///private/var/mobile/Library/Mobile%20Documents/com~apple~CloudDocs/Porno%20Mossegalapoma/programa_tipic_nomes_body.html")
    //var url = NSURL(URLWithString:"programa_tipic_nomes_body.html", relativeTo: baseURL)
    print(baseURL.absoluteString ?? "joder")
    if baseURL.startAccessingSecurityScopedResource() {
        
        do {
            if fm.fileExists(atPath: path) && fm.isReadableFile(atPath: path) {
                
                fileContent = try String(contentsOfFile: path, encoding: .utf8)
                
            
            }
            fileContent = try String(contentsOfFile: path, encoding: .utf8)
        }
        catch {
            print("no funca")
        }
        
    }
    else {
        print("No access")
    }
    baseURL.stopAccessingSecurityScopedResource()
    
    return fileContent
    
}

func uploadPost(draft:Bool, documentURL:String) -> Bool {
    
    let user = "publisher"
    let psw = "XbIb 8kS6 31Xw 2szM xVmd 58JK"
    let credentials = user + ":" + psw

    let token = credentials.data(using: String.Encoding.utf8)?.base64EncodedString()
    //Data is a byte buffer
    let decodedToken = Data(base64Encoded: token!)!
    
    //read html file
    
    let html_content:String = extractStringFromHTMLDocument(htmlDocURL: documentURL)
    print("HHHHHHHTTTTTTTTMMMMMLLLLLLL")
    print(html_content)

    let url_srcdest = URL(string: "http://192.168.1.128/wp-json/wp/v2/posts")
    guard let requestUrl = url_srcdest else { fatalError() }
    
    
    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    request.httpMethod = "POST"
    
    // Set HTTP Request Header
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Basic " + token!, forHTTPHeaderField: "Authorization")
    
    //print(String(data: decodedToken, encoding: .utf8)!)
    var status = "publish"
    if draft {
        status = "draft"
    }
        
    // Set HTTP Request Body
    let json: [String: Any] = ["title": "coco",
    "content": html_content,
    "status": status,
    "comment_status" : "open"]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    //request.httpBody = postString.data(using: String.Encoding.utf8);
    request.httpBody = jsonData
    
    
    
    var success = false
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
                if httpResponse.statusCode == 201 {
                    success =  true
                }
            }
       
                    
    }
    task.resume()
    return success
}
