//
//  ChooseScale.swift
//  Script_odont
//
//  Created by Régis Iozzino on 14/05/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

class ChooseScale
{
    struct Graduation
    {
        let title: String
        let code: Int
    }
    
    let graduations: [Graduation]
    
    init(graduations: [Graduation])
    {
        self.graduations = graduations
    }
    
    var count: Int {
        return self.graduations.count
    }
}
