//
//  Progression.swift
//  Script_odont
//
//  Created by Régis Iozzino on 18/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

/// User progression.
struct Progression
{
    /// The user mean score.
    var meanScore: Double
    
    /// The number of SCTs the user has finished.
    var answeredScts: Int
    
    /// The scores for the SCTs the user has finished.
    var scores: [Double]
}
