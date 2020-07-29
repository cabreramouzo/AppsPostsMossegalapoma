//
//  DocumentParser.swift
//  documentPicker
//
//  Created by MAC on 22/07/2020.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation
import SwiftSoup

import Ink

func parseMarkdown(inputString: String) -> String {
    
    //remove '  *' because produces a bug into de parser nesting lists to first item
    let inputStringWithoutSpacesInListItems = inputString.replacingOccurrences(of: "  *", with: "*")
    
    var mdparser = MarkdownParser()
    let modifier = Modifier(target: .paragraphs, closure: {html,markdown in
        var new_html = html
        var new_html2 = new_html.replacingOccurrences(of: "<p>", with: "")
        return new_html2.replacingOccurrences(of: "</p>", with: "")
    })
    
    mdparser.addModifier(modifier)
    
    
    
    let html = mdparser.html(from: inputStringWithoutSpacesInListItems)
    return html
    
}
