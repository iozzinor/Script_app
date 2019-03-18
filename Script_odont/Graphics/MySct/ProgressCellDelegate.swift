//
//  ProgressCellDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 18/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

protocol ProgressCellDelegate: class
{
    func progressCell(_ progressCell: ProgressCell, didChoosePeriod period: Period)
}
