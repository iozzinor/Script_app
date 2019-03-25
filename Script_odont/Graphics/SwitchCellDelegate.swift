//
//  SwitchCellDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 25/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

protocol SwitchCellDelegate: class
{
    func switchCell(_ switchCell: SwitchCell, didSelectValue value: Bool)
}
