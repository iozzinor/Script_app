//
//  CandidateStatistic.swift
//  Script_odont
//
//  Created by Régis Iozzino on 17/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

struct CandidateStatistics
{
    /// The candidate name.
    var name: String
    
    /// The candidate rank.
    var rank: Int
    
    /// The number of SCTs the candidate finished.
    var answeredScts: Int
    
    /// The candidate mean score.
    var meanScore: Double
}
