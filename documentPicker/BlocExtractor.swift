//
//  BlocExtractor.swift
//  documentPicker
//
//  Created by MAC on 22/07/2020.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation

func extractSingleBlock(inputStr:String, tag:String) -> String {
    
    do {
        
        let range = NSRange(location: 0, length: inputStr.utf16.count)
        let regex = try! NSRegularExpression(pattern: tag)
        
        if regex.firstMatch(in: inputStr, options: [], range: range) != nil {
            let numberOfMatches = regex.numberOfMatches(in: inputStr, range: range)
            
            if numberOfMatches == 2 {
                
                let results = regex.matches(in: inputStr, range: range)
                var ranges = [NSRange]()
                _ = results.map {
                    ranges.append($0.range)
                }
                var result = inputStr.dropLast(inputStr.count - ranges[1].lowerBound)
                result = result.dropFirst(ranges[0].upperBound)
                return String(result)
                
            }
            
            
        }
        
        
        
    }
    catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return "error"
    }
    return ""
}

func extractBlock(inputStr:String, tag:String) {
    
    
    
    
}
