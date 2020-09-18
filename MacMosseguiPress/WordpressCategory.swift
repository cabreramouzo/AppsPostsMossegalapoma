//
//  WordpressCategory.swift
//  MacMosseguiPress
//
//  Created by MAC on 16/09/2020.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation

struct WordpressCategory: Codable {
    
    var id = String()
    var name = String()
    var postDefault = Bool()
    
    init(wordpressId:String, name:String, Postdefault:Bool) {
        self.id = wordpressId
        self.name = name
        self.postDefault = Postdefault
    }
}
