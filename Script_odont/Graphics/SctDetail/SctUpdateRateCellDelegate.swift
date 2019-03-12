//
//  SctUpdateRateCellDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 13/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

protocol SctUpdateRateCellDelegate: class
{
    func sctUpdateRateCell(_ sctUpdateRateCell: SctUpdateRateCell, didChooseRate rate: Int)
}
