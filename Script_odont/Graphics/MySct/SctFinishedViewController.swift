//
//  SctFinishedViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 12/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SctFinishedViewController: SctDetailViewController
{
    var sctFinished: SctFinished =
        SctFinished(session: SctSession(exam: SctExam()),
                      answeredQuestions: 1,
                      duration: 30.0,
                      startDate: Date(),
                      endDate: Date(),
                      statistics:
            SctStatistics(id: 0, meanScore: 10, meanDuration: 94, meanVotes: 4.3, launchesCount: 300, meanCompletionPercentage: 60), score: 200, vote: nil)
    {
        didSet {
            if isViewLoaded
            {
                reloadData()
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    let sections: [SctDetailViewController.SctDetailSection] = [.general, .rate, .results, .duration, .popularity]
    
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
extension SctFinishedViewController: SctDetailViewDataSource
{
    var exam: SctExam {
        return sctFinished.session.exam
    }
    
    var statistics: SctStatistics {
        return sctFinished.statistics
    }
    
    var answeredQuestionsCount: Int {
        return sctFinished.answeredQuestions
    }
    
    var unfinished: SctUnfinished? {
        return nil
    }
    
    var finished: SctFinished? {
        return sctFinished
    }
    
    func rows(for section: SctDetailViewController.SctDetailSection, at index: Int) -> [SctDetailViewController.SctDetailRow]
    {
        switch section
        {
        case .general:
            return [.topic, .meanScore, .questionsCount]
        case .lastSession:
            return []
        case .rate:
            if sctFinished.vote != nil
            {
                return [.myVote, .removeVote]
            }
            
            return [.performVote]
        case .results:
            return [.completionDate, .completionDuration, .completionScore]
        case .duration:
            return [.estimatedDuration, .meanDuration]
        case .popularity:
            return [.votes, .launchesCount, .meanCompletionPercentage]
        }
    }
}
