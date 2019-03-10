//
//  SctHorizontalQuestionCellDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

public protocol SctHorizontalQuestionCellDelegate: class
{
    func sctHorizontalQuestionCell(_ sctHorizontalQuestionCell: SctHorizontalQuestionCell, didSelectAnswer answer: LikertSctle.Degree?)
}
