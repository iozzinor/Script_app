//
//  Array+utils.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/05/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

extension Array
{
    // -------------------------------------------------------------------------
    // JOIN
    // -------------------------------------------------------------------------
    /// - parameter joiner: The string joining the arguments.
    ///
    /// - returns: A string formed by joining the current array content with the `joiner`.
    func join(_ joiner: String) -> String
    {
        var result = ""
        
        for (i, element) in self.enumerated()
        {
            result += "\(element)"
            if i < self.count - 1
            {
                result += joiner
            }
        }
        
        return result
    }
}
