//
//  SctDetailViewDataSource.swift
//  Script_odont
//
//  Created by Régis Iozzino on 12/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

protocol SctDetailViewDataSource: class
{
    var exam: SctExam { get }
    var statistics: SctStatistics { get }
    var sections: [SctDetailViewController.SctDetailSection] { get }
    
    var answeredQuestionsCount: Int { get }
    
    var unfinished: SctUnfinished? { get }
    var finished: SctFinished? { get }
}
