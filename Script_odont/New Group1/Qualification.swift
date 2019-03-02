//
//  Qualification.swift
//  Script_odont
//
//  Created by Régis Iozzino on 02/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

enum Qualification
{
    case student
    case teacher([QualificationTopic])
    case expert([QualificationTopic])
}
