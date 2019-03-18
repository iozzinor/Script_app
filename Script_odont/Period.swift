//
//  Period.swift
//  Script_odont
//
//  Created by Régis Iozzino on 18/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

enum Period: Int, CaseIterable
{
    case day
    case week
    case month
    case year
    
    var shortName: String
    {
        switch self
        {
        case .day:
            return "Period.Day.Name.Short".localized
        case .week:
            return "Period.Week.Name.Short".localized
        case .month:
            return "Period.Month.Name.Short".localized
        case .year:
            return "Period.Year.Name.Short".localized
        }
    }
    
    var name: String
    {
        switch self
        {
        case .day:
            return "Period.Day.Name".localized
        case .week:
            return "Period.Week.Name".localized
        case .month:
            return "Period.Month.Name".localized
        case .year:
            return "Period.Year.Name".localized
        }
    }
}
