//
//  Sca.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

public struct Sca
{
    public var wording = ""
    public var topic = ScaTopic.diagnostic
    public var questions = [ScaQuestion]()
    
    /// - returns: Whether the given sca is valid.
    public static func isValid(_ sca: Sca, panelAnswer: ScaPanelAnswer) -> Bool
    {
        return false
    }
}
