//
//  PasswordPolicy.swift
//  Script_odont
//
//  Created by Régis Iozzino on 03/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

class PasswordPolicy
{
    static var shared = PasswordPolicy(traits: PasswordTrait.defaults())
    
    var traits: [PasswordTrait]
    
    init(traits: [PasswordTrait])
    {
        self.traits = traits
    }
    
    func isValid(password: String) -> Bool
    {
        for trait in traits
        {
            if !trait.isPasswordValid(password)
            {
                return false
            }
        }
        return true
    }
}
