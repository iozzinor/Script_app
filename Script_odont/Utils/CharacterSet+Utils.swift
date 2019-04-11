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
    static let urlQueryValueAllowed: CharacterSet = {
        
        let denied = ":#[]@!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: denied)
        return allowed
    }()
}
