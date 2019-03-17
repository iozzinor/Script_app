//
//  LatestPeriod.swift
//  Script_odont
//
//  Created by Régis Iozzino on 17/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

enum LatestPeriod: Int, CaseIterable
{
    case day
    case week
    case month
    case year
    
    var name: String {
        switch self
        {
        case .day:
            return "LatestPeriod.Day.Name".localized
        case .week:
            return "LatestPeriod.Week.Name".localized
        case .month:
            return "LatestPeriod.Month.Name".localized
        case .year:
            return "LatestPeriod.Year.Name".localized
        }
    }
}
