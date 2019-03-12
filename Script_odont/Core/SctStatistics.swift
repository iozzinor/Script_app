//
//  SctStatistics.swift
//  Script_odont
//
//  Created by Régis Iozzino on 11/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

public struct SctStatistics
{
    /// The id.
    var id: Int
    
    /// The mean score.
    var meanScore: Double
    
    /// The mean duration in seconds.
    var meanDuration: TimeInterval
    
    /// The mean votes (from 0 to 5).
    var meanVotes: Double
    
    /// The number of session launched.
    var launchesCount: Int
    
    /// The mean completion percentage.
    var meanCompletionPercentage: Double
}
