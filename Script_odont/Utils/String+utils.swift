//
//  String+localized.swift
//  Script_odont
//
//  Created by Régis Iozzino on 20/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

extension String
{
    // -------------------------------------------------------------------------
    // LOCALIZATION
    // -------------------------------------------------------------------------
    var localized: String
    {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with comment: String) -> String
    {
        return NSLocalizedString(self, comment: comment)
    }
    
    // -------------------------------------------------------------------------
    // JOIN
    // -------------------------------------------------------------------------
    func join<T: CustomStringConvertible>(_ arguments: Array<T>) -> String
    {
        var result = ""
        for (i, argument) in arguments.enumerated()
        {
            result += "\(argument)"
            if i < arguments.count - 1
            {
                result += self
            }
        }
        return result
    }
}
