//
//  SctHorizontalQuestionCellDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

public protocol SctItemCellDelegate: class
{
    func sctItemCell(_ sctItemCell: SctItemCell, didSelectAnswer answer: LikertScale.Degree?)
    
    func sctItemCell(didSelectPreviousItem sctItemCell: SctItemCell)
    func sctItemCell(didSelectNextItem sctItemCell: SctItemCell)
}
