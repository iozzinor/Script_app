//
//  SctPerformRateCellDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 12/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

protocol SctPerformRateCellDelegate: class
{
    func sctPerformRateCell(didCancelPerformRate sctPerformRateCell: SctPerformRateCell)
    func sctPerformRateCell(_ sctPerformRateCell: SctPerformRateCell, didChooseRate rate: Int)
}
