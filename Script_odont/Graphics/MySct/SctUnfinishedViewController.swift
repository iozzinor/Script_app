//
//  MySctUnfinishedViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 09/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SctUnfinishedViewController: UITableViewController
{
    // -------------------------------------------------------------------------
    // MARK: - SECTION
    // -------------------------------------------------------------------------
    fileprivate enum SctUnfinishedSection
    {
        case general
        case duration
        case popularity
        
        var headerTitle: String? {
            switch self
            {
            case .general:
                return "General"
            case .duration:
                return "Duration"
            case .popularity:
                return "Popularity"
            }
        }
        
        var rows: [SctUnfinishedRow]
        {
            switch self
            {
            case .general:
                return [.topic, .meanScore]
            case .duration:
                return [.answeredQuestionsCount, .estimatedDuration, .meanDuration]
            case .popularity:
                return [.votes, .launchesCount, .meanCompletionPercentage]
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ROW
    // -------------------------------------------------------------------------
    fileprivate enum SctUnfinishedRow
    {
        case topic
        case meanScore
        
        case answeredQuestionsCount
        case estimatedDuration
        case meanDuration
        
        case votes
        case launchesCount
        case meanCompletionPercentage
        
        func cell(for indexPath: IndexPath, sctUnfinishedViewController: SctUnfinishedViewController) -> UITableViewCell
        {
            let tableView = sctUnfinishedViewController.tableView!
            let sctUnfinished = sctUnfinishedViewController.sctUnfinished
            
            let cell = tableView.dequeueReusableCell(withIdentifier: SctUnfinishedViewController.cellId, for: indexPath)
            cell.textLabel?.textColor = Appearance.Color.default
            switch self
            {
            case .topic:
                cell.textLabel?.text = sctUnfinished.session.exam.scts.first?.topic.name
                cell.textLabel?.textColor = Appearance.Color.color(for: sctUnfinished.session.exam.scts.first?.topic ?? .diagnostic)
            case .meanScore:
                cell.textLabel?.text = ""
                
            case .answeredQuestionsCount:
                cell.textLabel?.text = "\(sctUnfinished.answeredQuestions)"
            case .estimatedDuration:
                let minutes = Int(sctUnfinished.duration / 60)
                let seconds = Int(sctUnfinished.duration) % 60
                cell.textLabel?.text = String(format: "%02d:%02d", minutes, seconds)
            case .meanDuration:
                cell.textLabel?.text = ""
                
            case .votes:
                cell.textLabel?.text = ""
            case .launchesCount:
                cell.textLabel?.text = ""
            case .meanCompletionPercentage:
                cell.textLabel?.text = ""
                
            }
            return cell
        }
    }
    
    public static let cellId = "SctUnfinishedCellReuseId"
    
    fileprivate var sections_: [SctUnfinishedSection] = [.general, .duration, .popularity]
    
    var sctUnfinished: SctUnfinished = SctUnfinished(session: SctSession(exam: SctExam()), answeredQuestions: 1, duration: 30.0, startDate: Date(), lastDate: Date())
    {
        didSet {
            if isViewLoaded
            {
                tableView.reloadData()
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDataSource
    // -------------------------------------------------------------------------
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return sections_.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let currentSection = sections_[section]
        return currentSection.rows.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let currentSection = sections_[section]
        return currentSection.headerTitle
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = sections_[indexPath.section]
        let row = section.rows[indexPath.row]
        
        return row.cell(for: indexPath, sctUnfinishedViewController: self)
    }
}
