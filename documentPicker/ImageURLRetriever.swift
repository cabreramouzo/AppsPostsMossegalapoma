//
//  ImageURLRetriever.swift
//  documentPicker
//
//  Created by MAC on 17/08/2020.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation

#if os(macOS)
import Cocoa

func getImageAttributes(imageID: Int, completion: @escaping (Bool, [String:String]) -> Void) {
    
    let settings: SettingsMac = SettingsMac()
    
    let user = settings.user
    let psw = settings.password
    let credentials = user + ":" + psw
    
    let token = credentials.data(using: String.Encoding.utf8)?.base64EncodedString()
    
    let url_srcdest = URL(string: settings.mediaServer + "/" + String(imageID) )
    print("peticio")
    print(url_srcdest)
    guard let requestUrl = url_srcdest else { fatalError() }

    
    // Prepare URL Request Object
    var request = URLRequest(url: requestUrl)
    
    request.setValue("Basic " + token!, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.httpMethod = "GET"
    
    struct MediaResponse: Codable { // or Decodable
        let id: Int?
    }
    
    // Perform HTTP Request
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        
        // Check for Error
        guard let dataResponse = data,
            error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                return
            }
        var imageDict = [String: String]()
        let imageId = String(imageID)
        
        do {
            //here dataResponse received from a network request
            if let jsonResponse = try JSONSerialization.jsonObject(with: dataResponse, options: []) as? Dictionary<String, Any> {
                print("converted dict")
                print(type(of: jsonResponse))
                print(jsonResponse)
                
                let imageURL = jsonResponse["source_url"] as! String
                let imageAlt = jsonResponse["alt_text"] as! String
                
                print("3 metadatos de la imagen")
                print(imageURL)
                print(imageAlt)
                print(imageId)
                
               imageDict = ["id":imageId,
                "url": imageURL,
                "alt": imageAlt]
                
                if let httpResponse = response as? HTTPURLResponse {
                           print("statusCode: \(httpResponse.statusCode)")
                           completion(httpResponse.statusCode == 200, imageDict)
                           
                }
            }
            
            
        }
        catch let parsingError {
            print("Error", parsingError)
        }
                    
        
    }
    //resume() will send the request
    task.resume()
    
    
    
}

#endif
