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
    fileprivate var sctFinished_: SctFinished =
        SctFinished(session: SctSession(exam: SctExam()),
                      answeredQuestions: 1,
                      duration: 30.0,
                      startDate: Date(),
                      endDate: Date(),
                      statistics:
            SctStatistics(id: 0, meanScore: 10, meanDuration: 94, meanVotes: 4.3, launchesCount: 300, meanCompletionPercentage: 60, scoresDistribution: [], releaseDate: Date()), score: 200, vote: nil)
    
    func setSctFinished(_ sctFinished: SctFinished)
    {
        sctFinished_ = sctFinished
        
        if isViewLoaded
        {
            reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    let sections: [SctDetailViewController.SctDetailSection] = [.general, .rate, .results, .duration, .popularity]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        setupTableView(tableView)
    }
}

// -----------------------------------------------------------------------------
// MARK: - SCT DETAIL VIEW DELEGATE
// -----------------------------------------------------------------------------
extension SctFinishedViewController: SctDetailViewDelegate
{
    func sctDetailView(_ sctDetailViewController: SctDetailViewController, didPerformVote vote: Int)
    {
        sctFinished_.vote = vote
        tableView.insertRows(at: [IndexPath(row: 1, section: 1)], with: .automatic)
        tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
    }
    
    func sctDetailView(_ sctDetailViewController: SctDetailViewController, didUpdateVote vote: Int)
    {
        sctFinished_.vote = vote
    }
    
    func sctDetailView(didRemoveVote sctDetailViewController: SctDetailViewController)
    {
        sctFinished_.vote = nil
        tableView.deleteRows(at: [IndexPath(row: 1, section: 1)], with: .automatic)
        tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
    }
}

// -----------------------------------------------------------------------------
// MARK: - SCT DETAIL VIEW DATA SOURCE
// -----------------------------------------------------------------------------
extension SctFinishedViewController: SctDetailViewDataSource
{
    var exam: SctExam {
        return sctFinished_.session.exam
    }
    
    var statistics: SctStatistics {
        return sctFinished_.statistics
    }
    
    var answeredQuestionsCount: Int {
        return sctFinished_.answeredQuestions
    }
    
    var unfinished: SctUnfinished? {
        return nil
    }
    
    var finished: SctFinished? {
        return sctFinished_
    }
    
    func rows(for section: SctDetailViewController.SctDetailSection, at index: Int) -> [SctDetailViewController.SctDetailRow]
    {
        switch section
        {
        case .general:
            return [.topic, .meanScore, .questionsCount, .scoreDiagram]
        case .lastSession:
            return []
        case .rate:
            if sctFinished_.vote != nil
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
