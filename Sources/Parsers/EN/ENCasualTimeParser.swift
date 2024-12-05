//
//  ENCasualTimeParser.swift
//  SwiftyChrono
//
//  Created by Jerry Chen on 1/18/17.
//  Copyright © 2017 Potix. All rights reserved.
//

import Foundation

private let PATTERN = "(\\W|^)((at)?\\s*(this|late)?\\s*(morning|afternoon|lunch|evening|dinner|noon))"
private let timeMatch = 5

public class ENCasualTimeParser: Parser {
    override var pattern: String { return PATTERN }
    
    override public func extract(text: String, ref: Date, match: NSTextCheckingResult, opt: [OptionType: Int]) -> ParsedResult? {
        let (matchText, index) = matchTextAndIndex(from: text, andMatchResult: match)
        var result = ParsedResult(ref: ref, index: index, text: matchText)
        
        if match.isNotEmpty(atRangeIndex: timeMatch) {
            let time = match.string(from: text, atRangeIndex: timeMatch)
            switch time {
            case "afternoon":
                result.start.imply(.hour, to: opt[.afternoon] ?? 15)
            case "lunch":
                result.start.imply(.hour, to: 11)
                result.start.imply(.minute, to: 30)
            case "evening":
                result.start.imply(.hour, to: opt[.evening] ?? 18)
            case "dinner":
                result.start.imply(.hour, to:  18)
            case "morning":
                result.start.imply(.hour, to: opt[.morning] ?? 6)
            case "noon":
                result.start.imply(.hour, to: opt[.noon] ?? 12)
            default: break
            }
        }
        
        result.tags[.enCasualTimeParser] = true
        return result
    }
}
