//
//  MySctViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 08/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class MySctViewController: UIViewController
{
    // -------------------------------------------------------------------------
    // MARK: - SECTIONS
    // -------------------------------------------------------------------------
    fileprivate enum MySctSection
    {
        case unfinished([SctUnfinished])
        case finished([SctFinished])
        
        var title: String? {
            switch self
            {
            case .unfinished:
                return "MySct.Section.Unfinished".localized
            case .finished:
                return "MySct.Section.Finished".localized
            }
        }
        
        var rows: [MySctRow]
        {
            switch self
            {
            case let .unfinished(unfinishedScts):
                return unfinishedScts.map {
                    return MySctRow.unfinished($0)
                }
            case let .finished(finishedScts):
                return finishedScts.map {
                    return MySctRow.finished($0)
                }
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ROWS
    // -------------------------------------------------------------------------
    fileprivate enum MySctRow
    {
        case unfinished(SctUnfinished)
        case finished(SctFinished)
        
        func cell(for indexPath: IndexPath, mySctViewController: MySctViewController) -> UITableViewCell
        {
            let tableView = mySctViewController.tableView!
            
            switch self
            {
            case let .unfinished(sctUnfinished):
                let cell = tableView.dequeueReusableCell(for: indexPath) as MySctUnfinishedCell
                cell.setSctUnfinished(sctUnfinished)
                cell.accessoryType = .disclosureIndicator
                return cell
            case let .finished(sctFinished):
                let cell = tableView.dequeueReusableCell(for: indexPath) as MySctFinishedCell
                cell.setSctFinished(sctFinished)
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        }
    }
    
    public static let toSctUnfinished = "MySctToSctUnfinishedSegueId"
    public static let toSctFinished = "MySctToSctFinishedSegueId"
    
    private static func defaultUnfinishedScts_() -> [SctUnfinished]
    {
        var scts = [Sct]()
        
        let sctsCount = Int(arc4random() % 10) + 2
        for _ in 0..<sctsCount
        {
            scts.append(Sct(wording: "", topic: .diagnostic, questions: Array<SctQuestion>(repeating: SctQuestion(), count: 10)))
        }
        
        var unfinishedScts = [SctUnfinished]()
        
        for i in 0..<5
        {
            let topic = SctTopic(rawValue: Constants.random(min: 0, max: 2)) ?? .diagnostic
            scts[0].topic = topic
            let exam = SctExam(scts: scts)
            let session = SctSession(exam: exam)
            
            let answeredQuestions = Constants.random(min: 5, max: 30)
            let duration = Double(Constants.random(min: 50, max: 350))
            let startDate = Date(timeIntervalSinceNow: Double(Constants.random(min: 0, max: 10) * (3600 * 24)))
            
            let statistics = SctStatistics(id: i + 1,
                                           meanScore:         Double(Constants.random(min: 5, max: 95)),
                                           meanDuration:                Double(Constants.random(min: 120, max: 300)),
                                           meanVotes:                   Double(Constants.random(min: 0, max: 500)) / 100.0,
                                           launchesCount:               Constants.random(min: 300, max: 1000),
                                           meanCompletionPercentage:    Double(Constants.random(min: 5, max: 95)))
            
            let sctUnfinished = SctUnfinished(session: session, answeredQuestions: answeredQuestions, duration: duration, startDate: startDate, lastDate: Date(), statistics: statistics)
            
            unfinishedScts.append(sctUnfinished)
        }
        
        unfinishedScts.sort(by: { $0.startDate > $1.startDate })
        
        return unfinishedScts
    }
    
    private static func defaultFinishedScts_() -> [SctFinished]
    {
        var scts = [Sct]()
        
        let sctsCount = Int(arc4random() % 10) + 2
        for _ in 0..<sctsCount
        {
            scts.append(Sct(wording: "", topic: .diagnostic, questions: Array<SctQuestion>(repeating: SctQuestion(), count: 10)))
        }
        
        var finishedScts = [SctFinished]()
        
        for i in 0..<5
        {
            let topic = SctTopic(rawValue: Int(arc4random() % 3)) ?? .diagnostic
            scts[0].topic = topic
            let exam = SctExam(scts: scts)
            let session = SctSession(exam: exam)
            
            let answeredQuestions = Int(arc4random() % 30) + 5
            let duration = Double(Int(arc4random() % 300) + 50)
            let startDate = Date(timeIntervalSinceNow: Double(Int(arc4random() % 10 * (3600 * 24))))
            let statistics = SctStatistics(id: i + 1,
                                           meanScore:         Double(Constants.random(min: 5, max: 95)),
                                           meanDuration:                Double(Constants.random(min: 120, max: 300)),
                                           meanVotes:                   Double(Constants.random(min: 0, max: 500)) / 100.0,
                                           launchesCount:               Constants.random(min: 300, max: 1000),
                                           meanCompletionPercentage:    Double(Constants.random(min: 5, max: 95)))
            let vote: Int? = nil//(Constants.random(min: 0, max: 100) % 2 == 0 ? nil : 3.75)
            
            let sctUnfinished = SctFinished(session: session, answeredQuestions: answeredQuestions, duration: duration, startDate: startDate, endDate: Date(), statistics: statistics, score: Double(arc4random() % 100 + 1), vote: vote)
            
            finishedScts.append(sctUnfinished)
        }
        
        finishedScts.sort(by: { $0.startDate > $1.startDate })
        
        return finishedScts
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var sections_: [MySctSection] = [ .unfinished(MySctViewController.defaultUnfinishedScts_()),
                                                  .finished(MySctViewController.defaultFinishedScts_())]
    fileprivate var sctUnfinished_: SctUnfinished? = nil
    fileprivate var sctFinished_: SctFinished? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Segues
    // -------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == MySctViewController.toSctUnfinished,
            let target = segue.destination as? SctUnfinishedViewController,
            let sctUnfinished = sctUnfinished_
        {
            target.sctUnfinished = sctUnfinished
        }
        else if segue.identifier == MySctViewController.toSctFinished,
            let target = segue.destination as? SctFinishedViewController,
            let sctFinished = sctFinished_
        {
            target.setSctFinished(sctFinished)
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - UITableViewDelegate
// -----------------------------------------------------------------------------
extension MySctViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let section = sections_[indexPath.section]
        let row = section.rows[indexPath.row]
        
        switch row
        {
        case let .unfinished(sctUnfinished):
            sctUnfinished_ = sctUnfinished
            performSegue(withIdentifier: MySctViewController.toSctUnfinished, sender: self)
        case let .finished(sctFinished):
            sctFinished_ = sctFinished
            performSegue(withIdentifier: MySctViewController.toSctFinished, sender: self)
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - UITableViewDataSource
// -----------------------------------------------------------------------------
extension MySctViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return sections_[section].title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return sections_.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let currentSection = sections_[section]
        return currentSection.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = sections_[indexPath.section]
        let row = section.rows[indexPath.row]
        
        let cell = row.cell(for: indexPath, mySctViewController: self)
        cell.selectionStyle = .none
        return cell
    }
}
