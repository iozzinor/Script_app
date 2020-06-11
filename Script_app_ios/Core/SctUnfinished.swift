//
//  SctFinished.swift
//  Script_odont
//
//  Created by Régis Iozzino on 09/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

public struct SctUnfinished
{
    var session: SctSession
    var answeredQuestions: Int
    var duration: TimeInterval
    
    var startDate: Date
    var lastDate: Date
    
    var information: SctLaunchInformation
}
