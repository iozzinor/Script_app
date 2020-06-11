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
    /// The localized string whose key is the current object.
    ///
    /// It is a convenience method that calls the `NSLocalizedString` one.
    var localized: String
    {
        return NSLocalizedString(self, comment: "")
    }
    
    /// - returns: The localized string whose key is the current string.
    func localized(with comment: String) -> String
    {
        return NSLocalizedString(self, comment: comment)
    }
    
    // -------------------------------------------------------------------------
    // JOIN
    // -------------------------------------------------------------------------
    /// - parameter arguments: Arguments to join.
    ///
    /// - returns: A string, formed by joining the arguments with the current one.
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
