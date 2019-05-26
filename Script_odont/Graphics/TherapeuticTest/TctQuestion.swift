//
//  TctQuestion.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/05/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

class TctQuestion
{
    var volumeFileName: String
    var wording:        String
    
    init(volumeFileName: String, wording: String)
    {
        self.volumeFileName = volumeFileName
        self.wording        = wording
    }
}
