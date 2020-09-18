//
//  CheckURLExists.swift
//  documentPicker
//
//  Created by MAC on 19/07/2020.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation

func checkURL(url:String, completion: @escaping(Bool) -> Void) -> Void {
    // https://storagemossegui.com/mlpaudio/mlp445.mp3
    
    guard let url = URL(string: url) else { return }

    var request = URLRequest(url: url)
    request.timeoutInterval = 2.0

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("\(error.localizedDescription)")
            completion(false)
        }
        if let httpResponse = response as? HTTPURLResponse {
            print("statusCode: \(httpResponse.statusCode)")
            completion(httpResponse.statusCode == 200)
        }
    }
    task.resume()

}
