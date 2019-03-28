//
//  SctHorizontalQuestionCellDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

public protocol SctQuestionCellDelegate: class
{
    func sctQuestionCell(_ sctQuestionCell: SctQuestionCell, didSelectAnswer answer: LikertScale.Degree?)
    
    func sctQuestionCell(didSelectPreviousQuestion sctQuestionCell: SctQuestionCell)
    func sctQuestionCell(didSelectNextQuestion sctQuestionCell: SctQuestionCell)
}
