//
//  TherapeuticChoiceDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 14/05/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

protocol TherapeuticChoiceDelegate: class
{
    func didSelectValue(at index: Int, for rowIndex: Int)
}
