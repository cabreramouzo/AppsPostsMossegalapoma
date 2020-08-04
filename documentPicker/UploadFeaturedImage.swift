//
//  UploadFeaturedImage.swift
//  documentPicker
//
//  Created by MAC on 16/07/2020.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation
#if !os(macOS)
import UIKit
#endif


#if os(macOS)
import Cocoa

func uploadImageMac(image: NSImage, imageTitle: String, imageAlternativetext: String, completion: @escaping (Bool, Int) -> Void) {
    
    let settings: SettingsMac = SettingsMac()
    
    var imageTitle2 = imageTitle
    var fileName2 = imageTitle
    var imageAltText = imageAlternativetext
    if imageTitle2 == "" {
        imageTitle2 = "Sense_titol.png"
    }
    else {
        fileName2 = imageTitle2.replacingOccurrences(of: " ", with: "_") + ".jpg"
    }
    
    if fileName2 == "" {
        fileName2 = "SenseNom.jpg"
    }
    
    if imageAltText == "" {
        imageAltText = imageTitle2.replacingOccurrences(of: "_", with: " ")
    }
    
    let user = settings.user
    let psw = settings.password
    let credentials = user + ":" + psw
    
    let token = credentials.data(using: String.Encoding.utf8)?.base64EncodedString()
    
    let urlParamsDict = ["alt_text=":imageAltText,
                     "author=": "2",
                     "title=":imageTitle2,
                    ]
    var urlParamsString = ""
    var counter = 0
    for (key, value) in urlParamsDict {
        var seperator = "?"
        if counter != 0 {
            seperator = "&"
        }
        urlParamsString += seperator + key + value.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        print(urlParamsString)
        counter+=1
    }
    
    let url_srcdest = URL(string: settings.mediaServer + urlParamsString)
    guard let requestUrl = url_srcdest else { fatalError() }
    
    //convert to data from https://gist.github.com/zappycode/3b5e151d4d98407901af5748745f5845
    let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)!
    let bitmapRep = NSBitmapImageRep(cgImage: cgImage)
    let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])!
    
    let postData = jpegData
    
    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    
    
    
    request.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
    request.setValue("Basic " + token!, forHTTPHeaderField: "Authorization")
    request.addValue("attachment; filename=" + fileName2, forHTTPHeaderField: "Content-Disposition")
    
    request.httpMethod = "POST"
    request.httpBody = postData
    
    struct MediaResponse: Codable { // or Decodable
        let id: Int?
    }
    
    // Perform HTTP Request
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        
        // Check for Error
        if let error = error {
            print("Error took place \(error)")
            completion(false, -1)
            return
        }
        
        // Convert HTTP Response Data to a String
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            print("Response data string:\n \(dataString)")
        }
        if let httpResponse = response as? HTTPURLResponse {
            print("statusCode: \(httpResponse.statusCode)")
            let mediaResponse: MediaResponse = try! JSONDecoder().decode(MediaResponse.self, from: data!)
            print("mediaresponse.id")
            print(mediaResponse.id)
            completion(httpResponse.statusCode == 201, mediaResponse.id ?? -1 )
            
        }
        
        
    }
    //resume() will send the request
    task.resume()
    
    
    
}

#endif

#if os(iOS)
func uploadImage(image: UIImage, imageTitle: String, fileName: String, completion: @escaping (Bool, Int) -> Void) -> Void {
    var imageTitle2 = imageTitle
    var fileName2 = fileName
    if imageTitle2 == "" {
        imageTitle2 = "Sense_titol.png"
    }
    
    if fileName2 == "" {
        fileName2 = "SenseNom.png"
    }
    
    
    let user = "publisher"
    let psw = "XbIb 8kS6 31Xw 2szM xVmd 58JK"
    let credentials = user + ":" + psw
    
    let token = credentials.data(using: String.Encoding.utf8)?.base64EncodedString()
    
    
    let url_srcdest = URL(string: "http://192.168.0.106/wp-json/wp/v2/media")
    guard let requestUrl = url_srcdest else { fatalError() }
    
    let postData = image.pngData()
    
    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    
    
    
    request.addValue("image/png", forHTTPHeaderField: "Content-Type")
    request.setValue("Basic " + token!, forHTTPHeaderField: "Authorization")
    request.addValue("attachment; filename=" + fileName2, forHTTPHeaderField: "Content-Disposition")
    
    request.httpMethod = "POST"
    request.httpBody = postData
    
    struct MediaResponse: Codable { // or Decodable
        let id: Int
    }
    
    // Perform HTTP Request
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        
        // Check for Error
        if let error = error {
            print("Error took place \(error)")
            completion(false, -1)
            return
        }
        
        // Convert HTTP Response Data to a String
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            print("Response data string:\n \(dataString)")
        }
        if let httpResponse = response as? HTTPURLResponse {
            print("statusCode: \(httpResponse.statusCode)")
            let mediaResponse: MediaResponse = try! JSONDecoder().decode(MediaResponse.self, from: data!)
            print("mediaresponse.id")
            print(mediaResponse.id)
            completion(httpResponse.statusCode == 201, mediaResponse.id )
            
        }
        
        
    }
    //resume() will send the request
    task.resume()
    
    
}
#endif
