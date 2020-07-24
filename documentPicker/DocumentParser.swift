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

    let mdparser = MarkdownParser()
    let html = mdparser.html(from: inputString)
    return html
    
}
