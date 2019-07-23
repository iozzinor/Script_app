//
//  String+hex.swift
//  Script_odont
//
//  Created by Régis Iozzino on 01/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

fileprivate func character_(forDigit digit: Int) -> CChar
{
    if digit < 10
    {
        let zeroOffset = CChar(Character("0").unicodeScalars.first!.value)
        return zeroOffset + CChar(digit)
    }
    else
    {
        let aOffset = CChar(Character("A").unicodeScalars.first!.value)
        return aOffset + CChar(digit - 10)
    }
}

extension String
{
    /// The hex representation of the current string.
    ///
    /// Letters are uppercased.
    var hex: String {
        var result = [CChar]()
        let cRepresentation = (cString(using: .utf8) ?? [])
        for (i, character) in cRepresentation.enumerated()
        {
            if i == cRepresentation.count - 1
            {
                continue
            }
            
            let upper = Int(character >> 4)
            let lower = Int(character & 0xF)
            
            result.append(character_(forDigit: upper))
            result.append(character_(forDigit: lower))
        }
        result.append(CChar(0))
        
        // return result
        return String(cString: &result)
    }
}
