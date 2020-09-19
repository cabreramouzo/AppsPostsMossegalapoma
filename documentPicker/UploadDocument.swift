//
//  UploadDocument.swift
//  documentPicker
//
//  Created by MAC on 09/07/2020.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation
#if os(iOS)
import UIKit
#endif

func getHTMLStringFromMdDocument(MdDocURL:URL, isMM:Bool, mediaAttributes:[String:String]) -> String {
    
    //let path = htmlDocURL
    var fileContent: String = ""
    var html: String = ""
    let fm = FileManager.default
    //extract path from URL
    
    let MdDocPath = MdDocURL.path
    print("PATH")
    print(MdDocPath)
    
    do {
        if fm.fileExists(atPath: MdDocPath) {
            
            if fm.isReadableFile(atPath: MdDocPath) {
                fileContent = try String(contentsOfFile: MdDocPath, encoding: .utf8)
                var tags = [String]()
                if isMM {
                    tags = ["%extracte%", "%part1%"]
                }
                else {
                    tags = ["%extracte%","%part1%","%part2%","%propostes%","%trukis%"]
                }
                let post = makePostFromGuioString(guioString: fileContent, mediaAttributes: mediaAttributes, arrayOfTags: tags )
                
                html = post.getPostHTML(isMM: isMM)
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
        
    
    return html
    
}

func uploadPost(draft:Bool, title: String, documentURL:URL, audioURL:String, mediaID:Int, categories:[Int], isMM:Bool, completion: @escaping (Bool) -> Void) -> Void {
    let settings: SettingsMac = SettingsMac()
    let user = settings.user
    let psw = settings.password
    let credentials = user + ":" + psw
    
    print("Categories array[]")
    print(categories)
    
    let token = credentials.data(using: String.Encoding.utf8)?.base64EncodedString()
    //Data is a byte buffer
    let decodedToken = Data(base64Encoded: token!)!
    
    //get media URL and other attributes to embed the featured image inside post
    var ok = false
    var imgDict = [String:String]()
    getImageAttributes(imageID: mediaID, completion: { (ok, imgDict) -> Void in
        if ok {
            print("retrieve image ok")

            //read html file
            let html_content:String = getHTMLStringFromMdDocument(MdDocURL: documentURL, isMM: isMM, mediaAttributes: imgDict)
            print("HTML content:")
            print(html_content)

            let url_srcdest = URL(string: settings.postServer)
            //TODO que no pete la app aqui
            guard let requestUrl = url_srcdest else { fatalError() }
            
            
            // Prepare URL Request Object
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "POST"
            
            // Set HTTP Request Header
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Basic " + token!, forHTTPHeaderField: "Authorization")
            print("token")
            print(String(data: decodedToken, encoding: .utf8)!)
            print(String(token!))
            var status = "publish"
            if draft {
                status = "draft"
            }
            
            let meta: [String: Any] = [
                "audio_file": audioURL]
                
            // Set HTTP Request Body
            let json: [String: Any] = [
            "title": title,
            "content": html_content,
            "status": status,
            "comment_status" : "open",
            "author" : settings.authorId,
            "featured_media" : mediaID,
            "meta" : meta,
            "categories" : categories,
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
                        
                        print("Response data string:\n \(dataString)")
                                      
                    }
                    if let httpResponse = response as? HTTPURLResponse {
                        print("statusCode: \(httpResponse.statusCode)")
                        
                        completion(httpResponse.statusCode == 201)
            
                    }
               
                            
            }
            //resume() will send the request
            task.resume()
            
        }
        else  {
            print("Cant retrieve image")
            
        }
    })
    
}
