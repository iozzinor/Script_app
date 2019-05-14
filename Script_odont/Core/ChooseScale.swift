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
    let meanings: [String]
    let start: Int
    let span: Int
    
    init(meanings: [String], start: Int, span: Int)
    {
        self.meanings = meanings
        self.start = start
        self.span = span
    }
    
    var count: Int {
        return self.meanings.count
    }
    
    subscript(value: Int) -> String
    { 
        let index = (value - start) / span
        return self.meanings[index]
    }
}
