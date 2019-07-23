//
//  CharacterSet+Utils.swift
//  Script_odont
//
//  Created by Régis Iozzino on 07/04/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

extension CharacterSet
{
    /// Set of characters allowed in an URL query.
    static let urlQueryValueAllowed: CharacterSet = {
        
        let denied = ":#[]@!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: denied)
        return allowed
    }()
}
