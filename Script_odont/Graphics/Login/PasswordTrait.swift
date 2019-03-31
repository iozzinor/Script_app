//
//  PasswordTrait.swift
//  Script_odont
//
//  Created by Régis Iozzino on 03/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

struct PasswordTrait
{
    static func defaults() -> [PasswordTrait]
    {
        var result = [PasswordTrait]()
        
        // between 8 and 2048 characters
        result.append(PasswordTrait {
            password -> Bool in
            if password.count < 8 || password.count > 2048
            {
                return false
            }
            return true
        })
        
        // at least an uppercase character
        result.append(PasswordTrait {
            password -> Bool in
            
            let passwordRange = NSRange(location: 0, length: password.count)
            let upper = try! NSRegularExpression(pattern: "[A-Z]")
            return upper.numberOfMatches(in: password, options: [], range:  passwordRange) > 0
        })
        
        // at least an lowercase character
        result.append(PasswordTrait {
            password -> Bool in
            
            let passwordRange = NSRange(location: 0, length: password.count)
            let lower = try! NSRegularExpression(pattern: "[a-z]")
            return lower.numberOfMatches(in: password, options: [], range:  passwordRange) > 0
        })
        
        // at least a digit
        result.append(PasswordTrait {
            password -> Bool in
            
            let passwordRange = NSRange(location: 0, length: password.count)
            let digit = try! NSRegularExpression(pattern: "[0-9]")
            return digit.numberOfMatches(in: password, options: [], range:  passwordRange) > 0
        })
        
        return result
    }
    
    var isPasswordValid: (String) -> Bool
}
