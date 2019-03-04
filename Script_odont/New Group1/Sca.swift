//
//  Sca.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

/// An SCA (Script Concordance Assessment).
public struct Sca
{
    /// The wording of the patient's problem.
    public var wording = ""
    
    /// The SCA topic.
    public var topic = ScaTopic.diagnostic
    
    /// Questions related the the patient's case.
    public var questions = [ScaQuestion]()
}
