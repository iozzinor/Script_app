//
//  MySctUnfinishedViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 09/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SctUnfinishedViewController: SctDetailViewController
{
    var sctUnfinished: SctUnfinished =
        SctUnfinished(session: SctSession(exam: SctExam()),
                      answeredQuestions: 1,
                      duration: 30.0,
                      startDate: Date(),
                      lastDate: Date(),
                      statistics:
            SctStatistics(id: 0, meanScore: 10, meanDuration: 94, meanVotes: 4.3, launchesCount: 300, meanCompletionPercentage: 60))
    {
        didSet {
            if isViewLoaded
            {
               reloadData()
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    let sections: [SctDetailViewController.SctDetailSection] = [.general, .lastSession, .duration, .popularity]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        dataSource = self
        setupTableView(tableView)
    }
}

// -----------------------------------------------------------------------------
// MARK: - SCT DETAIL VIEW DATA SOURCE
// -----------------------------------------------------------------------------
extension SctUnfinishedViewController: SctDetailViewDataSource
{
    func rows(for section: SctDetailViewController.SctDetailSection, at index: Int) -> [SctDetailViewController.SctDetailRow]
    {
        switch section
        {
        case .general:
            return [.topic, .meanScore, .questionsCount]
        case .lastSession:
            return [.lastDate, .actualDuration, .answeredQuestionsCount]
        case .rate:
            return []
        case .results:
            return []
        case .duration:
            return [.estimatedDuration, .meanDuration]
        case .popularity:
            return [.votes, .launchesCount, .meanCompletionPercentage]
        }
    }
    
    var exam: SctExam {
        return sctUnfinished.session.exam
    }
    
    var statistics: SctStatistics {
        return sctUnfinished.statistics
    }
    
    var answeredQuestionsCount: Int {
        return sctUnfinished.answeredQuestions
    }
    
    var unfinished: SctUnfinished? {
        return sctUnfinished
    }
    
    var finished: SctFinished? {
        return nil
    }
}
