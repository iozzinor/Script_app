//
//  ParticipantCategory.swift
//  Script_odont
//
//  Created by Régis Iozzino on 24/05/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

enum ParticipantCategory: CaseIterable
{
    case student4
    case student5
    case student6
    case intern
    case teacher
    
    var name: String {
        switch self {
        case .student4:
            return "ParticipantCategory.Name.Four".localized
        case .student5:
            return "ParticipantCategory.Name.Five".localized
        case .student6:
            return "ParticipantCategory.Name.Six".localized
        case .intern:
            return "ParticipantCategory.Name.Intern".localized
        case .teacher:
            return "ParticipantCategory.Name.Teacher".localized
        }
    }
}
