//
//  Post.swift
//  documentPicker
//
//  Created by MAC on 24/07/2020.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation

func makeDisplayNameFromTagName(tagName:String) -> String {
    if tagName == "%part1%" {
        return "PART 1:"
    }
    else if tagName == "%part2%" {
        return "PART 2:"
    }
    else if tagName == "%propostes%" {
        return "Propostes Mosseguis:"
    }
    else if tagName == "%trukis%" {
        return "Truquis Mosseguis:"
    }
    return ""
    
}

struct Post: Identifiable {
    var id = UUID()
    var sections = [String:PostSection]()
    
    mutating func addSection(name: String, markDownContent: String) {
        let displayTitle = makeDisplayNameFromTagName(tagName: name)
        let ps = PostSection(name: name, contentMD: markDownContent, displayTitle: displayTitle)
        self.sections[name] = ps
    }
    
    mutating func addSection(name: String, HTMLContent: String) {
        let displayTitle = makeDisplayNameFromTagName(tagName: name)
        let ps = PostSection(name: name, contentHTML: HTMLContent, displayTitle: displayTitle)
        self.sections[name] = ps
    }
    
    mutating func initDefaultHTMLSections() {
        
        let upc = PostSection(name: "upc", contentHTML: """
        <strong>Amb la col·laboració de la <a href="https://www.upc.edu/ca">Universitat Politècnica de Catalunya</a>.</strong>
        """, displayTitle: "")
            let hr = PostSection(name: "hr", contentHTML: "<hr />", displayTitle: "")
            let afiliats = PostSection(name: "afiliats", contentHTML: """

        <a href="https://www.amazon.es/iphone/s?k=iphone&amp;tag=mlpgestio05-21"><img class="aligncenter wp-image-30572 size-full" src="https://mossegalapoma.cat/imatges/afiliats_logo_black_510x120.jpg" alt="" width="510" height="120" /></a>

        <a href="https://open.spotify.com/show/6Qf368i6fgFGG2rfqUugth?si=x6szf6yYT2SARxwgjxGW_A"><img class="wp-image-30329 size-full aligncenter" src="https://mossegalapoma.cat/imatges/Spotify_Logo_RGB_Green_510_163.png" alt="" width="510" height="153" /></a>

        <a href="http://www.itunes.com/podcast?id=262710404"><img class="aligncenter wp-image-29680" src="https://mossegalapoma.cat/imatges/Listen-on-Apple-Podcasts-badge-1024x262-600x154.jpg" alt="" width="500" height="128" /></a>

        """, displayTitle: "")
        
        sections["upc"] = upc
        sections["hr"] = hr
        sections["afiliats"] = afiliats
    }
    
    func getSectionContentInHTML(sectionName:String) -> String {
        if sections[sectionName]?.contentType == PostContent.markdown {
            if let md = sections[sectionName]?.content {
                if let htmlTitle = sections[sectionName]?.htmlTitle {
                    return htmlTitle + parseMarkdown(inputString: md)
                }
                return parseMarkdown(inputString: md)
            }
        }
        else if sections[sectionName]?.contentType == PostContent.html {
            if let html = sections[sectionName]?.content {
                if let htmlTitle = sections[sectionName]?.htmlTitle {
                    return htmlTitle + html
                }
                return html
            }
        }
        
        
        return "sectionErrr"
    }
    
    func getPostHTML() -> String {
        
        var html:String = ""
        let orderTags = ["upc", "imatge", "%extracte%", "hr", "%part1%", "hr", "afiliats", "hr", "%part2%", "hr", "%propostes%", "hr", "%trukis%"]
        
        for sect in orderTags {
            html += self.getSectionContentInHTML(sectionName: sect)
            html += "\r\r"
        }
        
        return html
    }
    
    
}

enum PostContent:String {
    case html, markdown
}

struct PostSection {
    var name:String
    var htmlTitle:String?
    var content:String
    var contentType:PostContent
    
    init(name:String, contentMD:String, displayTitle:String) {
        self.name = name
        self.htmlTitle = ""
        if displayTitle != "" {
            self.htmlTitle = "<h2>" + displayTitle + "</h2>"
        }
        self.content = contentMD
        self.contentType = PostContent.markdown
    }
    init(name:String, contentHTML:String, displayTitle:String) {
        self.name = name
        self.htmlTitle = ""
        if displayTitle != "" {
            self.htmlTitle = "<h2>" + displayTitle + "</h2>"
        }
        self.content = contentHTML
        self.contentType = PostContent.html
    }

}



