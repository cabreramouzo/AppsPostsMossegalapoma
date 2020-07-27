//
//  BlocExtractor.swift
//  documentPicker
//
//  Created by MAC on 22/07/2020.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation

func makePostFromGuioString(guioString: String, arrayOfTags: [String]) -> Post {
        
    var p = Post()
    let tags = extractBlocks(arrayOfTags: arrayOfTags, guioString: guioString)
    for tag in tags{
        p.addSection(name: tag.key, markDownContent: tag.value)
    }
    return p
    
    
}

func extractBlocks(arrayOfTags: [String] , guioString: String) -> Dictionary<String, String> {
    
    var dict : [String: String] = [:]
    
    for tag in arrayOfTags {
        dict[tag] = extractBlock(inputStr: guioString, tag: tag)
    }
    return dict
}

/**
 This function returns a String wich is the result of appending the tag blocs in InputString. %tag1% Hi
 Mossegalapoma %tag1%, how its going ? %tag1% :)%tag1%  -> Hi Mossegalapoma :)
 */
func extractBlock(inputStr:String, tag:String) -> String {
    
    do {
        
        let range = NSRange(location: 0, length: inputStr.utf16.count)
        let regex = try! NSRegularExpression(pattern: tag)
        
        if regex.firstMatch(in: inputStr, options: [], range: range) != nil {
            let numberOfMatches = regex.numberOfMatches(in: inputStr, range: range)
            
            if numberOfMatches%2 == 0 {
                
                let results = regex.matches(in: inputStr, range: range)
                var ranges = [NSRange]()
                _ = results.map {
                    ranges.append($0.range)
                }

                var result = ""
                for index in stride(from: 0, through: ranges.count-1, by: 2){
                    var partialBlock = inputStr.dropLast(inputStr.count - ranges[index+1].lowerBound)
                    partialBlock = partialBlock.dropFirst(ranges[index].upperBound)
                    result.append(contentsOf: partialBlock)
                }
                
                return String(result)
            }
            else { return "error: Número de tags no parell" }
        }
    }
    catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return "error"
    }
    return ""
}

