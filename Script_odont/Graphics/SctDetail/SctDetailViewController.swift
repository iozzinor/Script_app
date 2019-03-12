//
//  SctDetail.swift
//  Script_odont
//
//  Created by Régis Iozzino on 12/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SctDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    static let cellId = "SctDetailCellReusedId"
    
    // -------------------------------------------------------------------------
    // MARK: - SECTION
    // -------------------------------------------------------------------------
    enum SctDetailSection
    {
        case general
        case lastSession
        case results
        case duration
        case popularity
        
        var headerTitle: String? {
            switch self
            {
            case .general:
                return "SctDetail.Section.General".localized
            case .lastSession:
                return "SctDetail.Section.LastSession".localized
            case .results:
                return "SctDetail.Section.Results".localized
            case .duration:
                return "SctDetail.Section.Duration".localized
            case .popularity:
                return "SctDetail.Section.Popularity".localized
            }
        }
        
        var rows: [SctDetailRow]
        {
            switch self
            {
            case .general:
                return [.topic, .meanScore, .questionsCount]
            case .lastSession:
                return [.lastDate, .actualDuration, .answeredQuestionsCount]
            case .results:
                return [.completionDate, .completionScore, .completionDuration]
            case .duration:
                return [.estimatedDuration, .meanDuration]
            case .popularity:
                return [.votes, .launchesCount, .meanCompletionPercentage]
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ROW
    // -------------------------------------------------------------------------
    enum SctDetailRow
    {
        // general
        case topic
        case meanScore
        case questionsCount
        
        // last session
        case lastDate
        case actualDuration
        case answeredQuestionsCount
        
        // completed session
        case completionDate
        case completionScore
        case completionDuration
        
        // duration
        case estimatedDuration
        case meanDuration
        
        // popularity
        case votes
        case launchesCount
        case meanCompletionPercentage
        
        func cell(for indexPath: IndexPath, sctDetailViewController: SctDetailViewController) -> UITableViewCell
        {
            guard let dataSource = sctDetailViewController.dataSource else
            {
                return UITableViewCell()
            }
            
            let cell = UITableViewCell(style: .value1, reuseIdentifier: SctDetailViewController.cellId)
            cell.textLabel?.textColor = Appearance.Color.default
            cell.selectionStyle = .none
            
            let numberFormatter = NumberFormatter()
            numberFormatter.locale = Locale.current
            numberFormatter.minimumFractionDigits = 1
            numberFormatter.maximumFractionDigits = 1
            numberFormatter.maximumIntegerDigits = 9
            numberFormatter.minimumIntegerDigits = 1
            let totalQuestionsCount = dataSource.exam.totalQuestionsCount
            switch self
            {
             // general
            case .topic:
                cell.textLabel?.text = dataSource.exam.topic.name
                cell.textLabel?.textColor = Appearance.Color.color(for: dataSource.exam.topic)
                cell.detailTextLabel?.text = ""
            case .meanScore:
                cell.textLabel?.text = "SctDetail.TableCell.MeanScore".localized
                let meanScore = numberFormatter.string(from: NSNumber(value: dataSource.statistics.meanVotes))!
                cell.detailTextLabel?.text = String.localizedStringWithFormat("SctDetail.TableCell.Detail.Score".localized, meanScore, totalQuestionsCount)
            case .questionsCount:
                cell.textLabel?.text = "SctDetail.TableCell.QuestionsCount".localized
                cell.detailTextLabel?.text = "\(totalQuestionsCount)"
                
            // last session
            case .lastDate:
                cell.textLabel?.text = "SctDetail.TableCell.LastDate".localized
                cell.detailTextLabel?.text = Constants.dateString(for: dataSource.unfinished?.lastDate ?? Date())
            case .actualDuration:
                let actualDuration = dataSource.unfinished?.duration ?? 0
                cell.textLabel?.text = "SctDetail.TableCell.ActualDuration".localized
                cell.detailTextLabel?.text = Constants.durationString(forTimeInterval: actualDuration)
            case .answeredQuestionsCount:
                let answeredQuestionsCount = dataSource.unfinished?.answeredQuestions ?? 0
                cell.textLabel?.text = "SctDetail.TableCell.AnsweredQuestionsCount".localized
                cell.detailTextLabel?.text = String.localizedStringWithFormat("SctDetail.TableCell.Detail.AnsweredQuestionsCount".localized, answeredQuestionsCount, totalQuestionsCount)
                
            // completed session
            case .completionDate:
                cell.textLabel?.text = "SctDetail.TableCell.CompletionDate".localized
                
                let completionDate = dataSource.finished?.endDate ?? Date()
                cell.detailTextLabel?.text = Constants.dateString(for: completionDate)
            case .completionScore:
                cell.textLabel?.text = "SctDetail.TableCell.CompletionScore".localized
                
                let score = dataSource.finished?.score ?? 0
                let scoreString = numberFormatter.string(from: NSNumber(value: score))!
                cell.detailTextLabel?.text = String.localizedStringWithFormat("SctDetail.TableCell.Detail.Score".localized, scoreString, totalQuestionsCount)
            case .completionDuration:
                cell.textLabel?.text = "SctDetail.TableCell.CompletionDuration".localized
                let completionDuration = dataSource.finished?.duration ?? 0
                cell.detailTextLabel?.text = Constants.durationString(forTimeInterval: completionDuration)
                
            // duration
            case .estimatedDuration:
                cell.textLabel?.text = "SctDetail.TableCell.EstimatedDuration".localized
                cell.detailTextLabel?.text = Constants.durationString(forTimeInterval: dataSource.exam.estimatedDuration)
            case .meanDuration:
                cell.textLabel?.text = "SctDetail.TableCell.MeanDuration".localized
                cell.detailTextLabel?.text = Constants.durationString(forTimeInterval: dataSource.statistics.meanDuration)
                
            // popularity
            case .votes:
                cell.textLabel?.text = "SctDetail.TableCell.MeanVotes".localized
                cell.detailTextLabel?.text = numberFormatter.string(from: NSNumber(value: dataSource.statistics.meanVotes))
            case .launchesCount:
                cell.textLabel?.text = "SctDetail.TableCell.LaunchesCount".localized
                numberFormatter.minimumFractionDigits = 0
                numberFormatter.maximumFractionDigits = 0
                cell.detailTextLabel?.text = numberFormatter.string(from: NSNumber(value: dataSource.statistics.launchesCount))
            case .meanCompletionPercentage:
                cell.textLabel?.text = "SctDetail.TableCell.MeanCompletionPercentage".localized
                
                let meanCompletionPercentage = numberFormatter.string(from: NSNumber(value: dataSource.statistics.meanCompletionPercentage))!
                cell.detailTextLabel?.text = String.localizedStringWithFormat("SctDetail.TableCell.Detail.MeanCompletionPerentage".localized, meanCompletionPercentage)
                
            }
            return cell
        }
    }
    
    var dataSource: SctDetailViewDataSource? = nil
    fileprivate var sections_: [SctDetailSection] {
        return dataSource?.sections ?? []
    }
    fileprivate weak var tableView_: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        updateUi_()
    }
    
    func setupTableView(_ tableView: UITableView)
    {
        tableView_ = tableView
        tableView.delegate      = self
        tableView.dataSource    = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: SctDetailViewController.cellId)
    }
    
    func reloadData()
    {
        updateUi_()
    }
    
    fileprivate func updateUi_()
    {
        updateTableView_()
        updateTitle_()
    }
    
    fileprivate func updateTableView_()
    {
        tableView_?.reloadData()
    }
    
    fileprivate func updateTitle_()
    {
        navigationItem.title = String.localizedStringWithFormat("SctDetail.Title".localized, dataSource?.statistics.id ?? 0)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDelegate
    // -------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        return nil
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDataSource
    // -------------------------------------------------------------------------
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return sections_.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let currentSection = sections_[section]
        return currentSection.rows.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let currentSection = sections_[section]
        return currentSection.headerTitle
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = sections_[indexPath.section]
        let row = section.rows[indexPath.row]
        
        return row.cell(for: indexPath, sctDetailViewController: self)
    }
}
