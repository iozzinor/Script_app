//
//  SctViewDataSource.swift
//  Script_odont
//
//  Created by Régis Iozzino on 11/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

public protocol SctViewDataSource: SctQuestionCellDelegate
{
    var sections: [SctViewController.SctSection] { get}
    
    var currentSctIndex: Int { get }
    var currentSct: Sct { get }
    
    var questionHeaderTitle: SctQuestionHeaderCell.Title? { get}

    var session: SctSession? { get }
    
    var canChooseLikertScale: Bool { get }
}
