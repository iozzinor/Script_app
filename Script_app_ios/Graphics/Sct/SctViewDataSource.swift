//
//  SctViewDataSource.swift
//  Script_odont
//
//  Created by Régis Iozzino on 11/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

public protocol SctViewDataSource: SctItemCellDelegate
{
    // -------------------------------------------------------------------------
    // MARK: - DELEGATE
    // -------------------------------------------------------------------------
    var newDataDelegate: NewDataDelegate? { get }
    
    var sections: [SctViewController.SctSection] { get}
    
    var currentSctQuestionIndex: Int { get }
    var currentSctQuestion: SctQuestion { get }
    
    var questionHeaderTitle: SctQuestionHeaderCell.Title? { get }

    var session: SctSession? { get }
    
    var canChooseLikertScale: Bool { get }
    
    // -------------------------------------------------------------------------
    // MARK: - SINGLE QUESTION
    // -------------------------------------------------------------------------
    var shouldDisplaySingleQuestion: Bool { get}
    var singleQuestionIndex: Int? { get }
}
