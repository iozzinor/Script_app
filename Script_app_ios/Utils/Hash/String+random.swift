//
//  String+random.swift
//  Script_odont
//
//  Created by Régis Iozzino on 02/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation
import CommonCrypto

extension String
{
    /// Generates a random string, whose length is `length`.
    ///
    /// As security matters, it generates the string using the `CCRandomGeneratedBytes`
    /// function that can be used to generated cipher strings.
    ///
    /// - parameter length: The new string length.
    ///
    /// - returns: The random string.
    static func random(length: Int) -> String
    {
        if length < 1
        {
            return ""
        }
        
        let bytesCount = (length % 2 == 0 ? length / 2 : length / 2 + 1)
        var resultData = Data(count: bytesCount)
        
        _ = resultData.withUnsafeMutableBytes({
            bytes in
            CCRandomGenerateBytes(bytes, bytesCount)
        })
        
        let result = resultData.map {
            String(format: "%02hhx", $0)
        }.joined()
        
        if result.count == length
        {
            return result
        }
        
        let endIndex = result.index(before: result.endIndex)
        return String(result[result.startIndex..<endIndex])
    }
}
