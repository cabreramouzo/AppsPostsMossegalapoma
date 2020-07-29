//
//  UploadFeaturedImage.swift
//  documentPicker
//
//  Created by MAC on 16/07/2020.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation
import UIKit


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
