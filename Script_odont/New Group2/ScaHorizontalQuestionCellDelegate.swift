//
//  ScaHorizontalQuestionCellDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

public protocol ScaHorizontalQuestionCellDelegate: class
{
    func scaHorizontalQuestionCell(_ scaHorizontalQuestionCell: ScaHorizontalQuestionCell, didSelectAnswer answer: LikertScale.Degree?)
}
