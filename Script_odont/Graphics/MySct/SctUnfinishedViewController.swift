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
                return "MySct.SctUnfinished.Section.General".localized
            case .duration:
                return "MySct.SctUnfinished.Section.Duration".localized
            case .popularity:
                return "MySct.SctUnfinished.Section.Popularity".localized
            }
        }
        
        var rows: [SctUnfinishedRow]
        {
            switch self
            {
            case .general:
                return [.topic, .meanScore, .answeredQuestionsCount]
            case .duration:
                return [.actualDuration, .estimatedDuration, .meanDuration]
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
        
        case actualDuration
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
            cell.selectionStyle = .none
            
            let numberFormatter = NumberFormatter()
            numberFormatter.locale = Locale.current
            numberFormatter.minimumFractionDigits = 1
            numberFormatter.maximumFractionDigits = 1
            let totalQuestionsCount = sctUnfinished.session.totalQuestionsCount
            switch self
            {
            case .topic:
                cell.textLabel?.text = sctUnfinished.session.exam.scts.first?.topic.name
                cell.textLabel?.textColor = Appearance.Color.color(for: sctUnfinished.session.exam.scts.first?.topic ?? .diagnostic)
                cell.detailTextLabel?.text = ""
            case .meanScore:
                cell.textLabel?.text = "MySct.SctUnfinished.TableCell.MeanScore".localized
                let meanScore = numberFormatter.string(from: NSNumber(value: sctUnfinished.statistics.meanVotes))!
                cell.detailTextLabel?.text = String.localizedStringWithFormat("MySct.SctUnfinished.TableCell.Detail.MeanScore".localized, meanScore, totalQuestionsCount)
            case .answeredQuestionsCount:
                cell.textLabel?.text = "MySct.SctUnfinished.TableCell.AnsweredQuestionsCount".localized
                cell.detailTextLabel?.text = String.localizedStringWithFormat("MySct.SctUnfinished.TableCell.Detail.AnsweredQuestionsCount".localized, sctUnfinished.answeredQuestions, totalQuestionsCount)
                
            case .actualDuration:
                cell.textLabel?.text = "MySct.SctUnfinished.TableCell.ActualDuration".localized
                cell.detailTextLabel?.text = Constants.durationString(forTimeInterval: sctUnfinished.duration)
            case .estimatedDuration:
                cell.textLabel?.text = "MySct.SctUnfinished.TableCell.EstimatedDuration".localized
                cell.detailTextLabel?.text = Constants.durationString(forTimeInterval: sctUnfinished.session.estimatedDuration)
            case .meanDuration:
                cell.textLabel?.text = "MySct.SctUnfinished.TableCell.MeanDuration".localized
                cell.detailTextLabel?.text = Constants.durationString(forTimeInterval: sctUnfinished.statistics.meanDuration)
                
            case .votes:
                cell.textLabel?.text = "MySct.SctUnfinished.TableCell.MeanVotes".localized
                cell.detailTextLabel?.text = numberFormatter.string(from: NSNumber(value: sctUnfinished.statistics.meanVotes))
            case .launchesCount:
                cell.textLabel?.text = "MySct.SctUnfinished.TableCell.LaunchesCount".localized
                numberFormatter.minimumFractionDigits = 0
                numberFormatter.maximumFractionDigits = 0
                cell.detailTextLabel?.text = numberFormatter.string(from: NSNumber(value: sctUnfinished.statistics.launchesCount))
            case .meanCompletionPercentage:
                cell.textLabel?.text = "MySct.SctUnfinished.TableCell.MeanCompletionPercentage".localized
                
                let meanCompletionPercentage = numberFormatter.string(from: NSNumber(value: sctUnfinished.statistics.meanCompletionPercentage))!
                cell.detailTextLabel?.text = String.localizedStringWithFormat("MySct.SctUnfinished.TableCell.Detail.MeanCompletionPerentage".localized, meanCompletionPercentage)
                
            }
            return cell
        }
    }
    
    public static let cellId = "SctUnfinishedCellReuseId"
    
    fileprivate var sections_: [SctUnfinishedSection] = [.general, .duration, .popularity]
    
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
                updateUi_()
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        updateUi_()
    }
    
    fileprivate func updateUi_()
    {
        updateTableView_()
        updateTitle_()
    }
    
    fileprivate func updateTableView_()
    {
         tableView.reloadData()
    }
    
    fileprivate func updateTitle_()
    {
        navigationItem.title = String.localizedStringWithFormat("MySct.SctUnfinished.Title".localized, sctUnfinished.statistics.id)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDelegate
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        return nil
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
