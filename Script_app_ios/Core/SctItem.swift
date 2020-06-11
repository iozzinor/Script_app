//
//  SctQuestion.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

/// An SCT item.
public struct SctItem
{
    /// The hypothesis.
    public var hypothesis: String = ""
    
    /// The new data that might affect the hypothesis.
    public var newData = SctData()
}
