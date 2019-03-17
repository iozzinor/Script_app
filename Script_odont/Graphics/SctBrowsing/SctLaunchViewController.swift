//
//  SctLaunchViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 17/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SctLaunchViewController: SctDetailViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    var launchInformation = SctLaunchInformation(exam: SctExam(),
                                                 statistics: SctStatistics(id: 0, meanScore: 10, meanDuration: 94, meanVotes: 4.3, launchesCount: 300, meanCompletionPercentage: 60, scoresDistribution: [], releaseDate: Date()))
    {
        didSet
        {
            if isViewLoaded
            {
                super.reloadData()
            }
        }
    }
    
    let sections: [SctDetailViewController.SctDetailSection] = [ .general, .duration, .popularity, .other]
    
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
extension SctLaunchViewController: SctDetailViewDelegate
{
    func sctDetailView(_ sctDetailViewController: SctDetailViewController, didPerformVote vote: Int)
    {
    }
    
    func sctDetailView(_ sctDetailViewController: SctDetailViewController, didUpdateVote vote: Int)
    {
    }
    
    func sctDetailView(didRemoveVote sctDetailViewController: SctDetailViewController)
    {
    }
    
    func sctDetailView(didResume sctDetailViewController: SctDetailViewController)
    {
    }
    
    func sctDetailView(didLaunch sctDetailViewController: SctDetailViewController)
    {
        print("launch SCT")
    }
}

// -----------------------------------------------------------------------------
// MARK: - SCT DETAIL VIEW DATA SOURCE
// -----------------------------------------------------------------------------
extension SctLaunchViewController: SctDetailViewDataSource
{
    var exam: SctExam {
        return launchInformation.exam
    }
    
    var statistics: SctStatistics {
        return launchInformation.statistics
    }
    
    var answeredQuestionsCount: Int {
        return launchInformation.exam.totalQuestionsCount
    }
    
    var unfinished: SctUnfinished? {
        return nil
    }
    
    var finished: SctFinished? {
        return nil
    }
    
    func rows(for section: SctDetailViewController.SctDetailSection, at index: Int) -> [SctDetailViewController.SctDetailRow]
    {
        switch section
        {
        case .general:
            return [.topic, .meanScore, .questionsCount, .scoreDiagram]
        case .lastSession, .rate, .results:
            return []
        case .duration:
            return [.estimatedDuration, .meanDuration]
        case .popularity:
            return [.votes, .launchesCount, .meanCompletionPercentage]
        case .other:
            return [.launch]
        }
    }
}
