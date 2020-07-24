//
//  UploadDocument.swift
//  documentPicker
//
//  Created by MAC on 09/07/2020.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation
import UIKit


func extractStringFromHTMLDocument(htmlDocURL:URL) -> String {
    
    //let path = htmlDocURL
    var fileContent: String = ""
    let fm = FileManager.default
    //extract path from URL
    
    let htmlDocPath = htmlDocURL.path
    print("PATH")
    print(htmlDocPath)
    
    do {
        if fm.fileExists(atPath: htmlDocPath) {
            
            if fm.isReadableFile(atPath: htmlDocPath) {
                fileContent = try String(contentsOfFile: htmlDocPath, encoding: .utf8)
                let post = makePostFromGuioString(guioString: fileContent, arrayOfTags: ["%extracte%","%part1%","%part2%","%propostes%","%trukis%"])
                
                let html = post.getPostHTML()
                print (html)
            }
            else {
                print("FILE NO READABLE")
            }
        }
        else {
            print("FILE NOT EXIST")
        }
    }
    catch {
        print("no funca")
    }
        
    
    return fileContent
    
}

func uploadPost(draft:Bool, title: String, documentURL:URL, mediaID:Int, completion: @escaping (Bool) -> Void) -> Void {
    
    let user = "publisher"
    let psw = "XbIb 8kS6 31Xw 2szM xVmd 58JK"
    let credentials = user + ":" + psw

    let token = credentials.data(using: String.Encoding.utf8)?.base64EncodedString()
    //Data is a byte buffer
    let decodedToken = Data(base64Encoded: token!)!
    
    //read html file
    let html_content:String = extractStringFromHTMLDocument(htmlDocURL: documentURL)
    //print("HTML content:")
    //print(html_content)

    let url_srcdest = URL(string: "http://192.168.1.130/wp-json/wp/v2/posts")
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
    
    let meta: [String: Any] = [
        "audio_file": "https://storagemossegui.com/mlpaudio/mlp445.mp3"]
        
    // Set HTTP Request Body
    let json: [String: Any] = ["title": title,
    "content": html_content,
    "status": status,
    "comment_status" : "open",
    "featured_media" : mediaID,
    "meta" : meta,
    ]
    
    print("featured media ID")
    print(mediaID)
    
    let jsonData = try? JSONSerialization.data(withJSONObject: json)
    //request.httpBody = postString.data(using: String.Encoding.utf8);
    request.httpBody = jsonData

    // Perform HTTP Request
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        
            
        
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                completion(false)
                return
            }
     
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                //print("Response data string:\n \(dataString)")
                              
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("statusCode: \(httpResponse.statusCode)")
                
                completion(httpResponse.statusCode == 201)
    
            }
       
                    
    }
    //resume() will send the request
    task.resume()
}
