//
//  SctLaunchInformation.swift
//  Script_odont
//
//  Created by Régis Iozzino on 15/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

/// Information to display to the user before launching an SCT.
struct SctLaunchInformation
{
    /// The SCT topic.
    var topic: SctTopic
    
    /// The author last name.
    var authorLastName: String
    
    /// The author first name.
    var authorFirstName: String
    
    /// The estimated duration.
    var estimatedDuration: TimeInterval
    
    /// The number of questions in the SCT.
    var questionsCount: Int
    
    /// SCT statitics.
    var statistics: SctStatistics
}
