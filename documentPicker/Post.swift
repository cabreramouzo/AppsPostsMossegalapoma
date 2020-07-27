//
//  Post.swift
//  documentPicker
//
//  Created by MAC on 24/07/2020.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation

struct Post: Identifiable {
    var id = UUID()
    var sections = [String:PostSection]()
    
    mutating func addSection(name: String, markDownContent: String) {
        let ps = PostSection(name: name, content: markDownContent)
        self.sections[name] = ps
    }
    
    func getSectionContentInHTML(sectionName:String) -> String {
        if let md = sections[sectionName]?.content {
            return parseMarkdown(inputString: md)
        }
        
        return "sectionErrr"
    }
    
    func getPostHTML() -> String {
        
        var html:String = ""
        let orderTags = ["%extracte%","%part1%","%part2%","%propostes%","%trukis%"]
        
        for sect in orderTags {
            html += self.getSectionContentInHTML(sectionName: sect)
        }
        
        return html
    }
    
    
}

struct PostSection {
    var name:String
    var content:String
    
    init(name:String, content:String) {
        self.name = name
        self.content = content
    }

}



