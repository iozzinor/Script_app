//
//  SctFinishedViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 12/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

fileprivate func defaultSctFinished_() -> SctFinished
{
    let statistics = SctStatistics(id: 0, meanScore: 10, meanDuration: 94, meanVotes: 4.3, launchesCount: 300, meanCompletionPercentage: 60, scoresDistribution: [])
    
    let information = SctLaunchInformation(type: .diagnostic, releaseDate: Date(), authorLastName: "Tartanpion", authorFirstName: "Jean", estimatedDuration: 34, questionsCount: 10, statistics: statistics)
    return SctFinished(session: SctSession(sct: Sct()),
                    answeredQuestions: 1,
                    duration: 30.0,
                    startDate: Date(),
                    endDate: Date(),
                    information: information, score: 200, vote: nil)
    
}

class SctFinishedViewController: SctDetailViewController
{
    fileprivate var sctFinished_ = defaultSctFinished_()
    
    func setSctFinished(_ sctFinished: SctFinished)
    {
        sctFinished_ = sctFinished
        
        if isViewLoaded
        {
            super.reloadData()
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
    
    func sctDetailView(didResume sctDetailViewController: SctDetailViewController)
    {
    }
    
    func sctDetailView(didLaunch sctDetailViewController: SctDetailViewController)
    {
    }
}

// -----------------------------------------------------------------------------
// MARK: - SCT DETAIL VIEW DATA SOURCE
// -----------------------------------------------------------------------------
extension SctFinishedViewController: SctDetailViewDataSource
{
    var sct: Sct {
        return sctFinished_.session.sct
    }
    
    var information: SctLaunchInformation {
        return sctFinished_.information
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
            return [.type, .authorLastName, .authorFirstName, .meanScore, .questionsCount, .scoreDiagram]
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
            
        case .other:
            return []
        }
    }
}
