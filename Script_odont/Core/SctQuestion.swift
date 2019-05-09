//
//  Sct.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

/// An SCT question.
public struct SctQuestion
{
    /// The wording of the patient's problem.
    public var wording = ""
    
    /// The SCT type.
    public var type = SctType.diagnostic
    
    /// Questions related the the patient's case.
    public var items = [SctItem]()
}
