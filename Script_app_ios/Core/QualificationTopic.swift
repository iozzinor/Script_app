//
//  QualificationTopic.swift
//  Script_odont
//
//  Created by Régis Iozzino on 02/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

enum QualificationTopic: Int, CaseIterable
{
    case surgery
    case endodontics
    case prosthodontics
    case pediatricDentistry
    case periodontics
    
    var name: String
    {
        switch self
        {
        case .surgery:
            return "QualificationTopic.Name.Surgery".localized
        case .endodontics:
            return "QualificationTopic.Name.Endodontics".localized
        case .prosthodontics:
            return "QualificationTopic.Name.Prosthodontics".localized
        case .pediatricDentistry:
            return "QualificationTopic.Name.PediatricDentistry".localized
        case .periodontics:
            return "QualificationTopic.Name.Periodontics".localized
        }
    }
}
