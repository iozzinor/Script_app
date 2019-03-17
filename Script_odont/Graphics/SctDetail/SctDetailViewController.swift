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
        case rate
        case results
        case duration
        case popularity
        case other
        
        var headerTitle: String? {
            switch self
            {
            case .general:
                return "SctDetail.Section.General".localized
            case .lastSession:
                return "SctDetail.Section.LastSession".localized
            case .rate:
                return "SctDetail.Section.Rate".localized
            case .results:
                return "SctDetail.Section.Results".localized
            case .duration:
                return "SctDetail.Section.Duration".localized
            case .popularity:
                return "SctDetail.Section.Popularity".localized
            case .other:
                return nil
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
        case scoreDiagram
        
        // last session
        case lastDate
        case actualDuration
        case answeredQuestionsCount
        
        // completed session
        case myVote
        case performVote
        case removeVote
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
        
        // resume
        case resume
        
        // launch
        case launch
        
        func cell(for indexPath: IndexPath, sctDetailViewController: SctDetailViewController) -> UITableViewCell
        {
            guard let dataSource = sctDetailViewController.dataSource else
            {
                return UITableViewCell()
            }
            
            let tableView = sctDetailViewController.tableView_!
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
            case .scoreDiagram:
                let result = tableView.dequeueReusableCell(for: indexPath) as SctScoreDiagramCell
                result.scoresDistribution = dataSource.statistics.scoresDistribution
                result.selectionStyle = .none
                
                if let finished = dataSource.finished
                {
                    let percentRange = 100.0 / Double(dataSource.statistics.scoresDistribution.count)
                    result.scoreDiagram.selectedBarIndex = Int(finished.score / Double(dataSource.exam.totalQuestionsCount) * 100.0 / percentRange)
                }
                
                return result
                
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
                
            // rate
            case .myVote:
                let result = tableView.dequeueReusableCell(for: indexPath) as SctUpdateRateCell
                result.updateLabel?.text = "SctDetail.TableCell.MyVote".localized
                result.selectedStar = (dataSource.finished?.vote ?? 1) - 1
                result.selectionStyle = .none
                result.delegate = sctDetailViewController
                return result
            case .performVote:
                let result = tableView.dequeueReusableCell(for: indexPath) as SctPerformRateCell
                result.performRateButton.setTitle("SctDetail.TableCell.PerformVote".localized, for: .normal)
                result.delegate = sctDetailViewController
                result.selectionStyle = .none
                sctDetailViewController.performRateCell_ = result
                result.reset()
                return result
            case .removeVote:
                cell.textLabel?.text = "SctDetail.TableCell.RemoveVote".localized
                cell.textLabel?.textColor = Appearance.Color.action
                cell.detailTextLabel?.text = ""
                sctDetailViewController.removeRateIndex_ = indexPath
                
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
                let result = tableView.dequeueReusableCell(for: indexPath) as SctRateCell
                result.rateLabel.text = "SctDetail.TableCell.MeanVotes".localized
                result.rate = dataSource.statistics.meanVotes
                return result
            case .launchesCount:
                cell.textLabel?.text = "SctDetail.TableCell.LaunchesCount".localized
                numberFormatter.minimumFractionDigits = 0
                numberFormatter.maximumFractionDigits = 0
                cell.detailTextLabel?.text = numberFormatter.string(from: NSNumber(value: dataSource.statistics.launchesCount))
            case .meanCompletionPercentage:
                cell.textLabel?.text = "SctDetail.TableCell.MeanCompletionPercentage".localized
                
                let meanCompletionPercentage = numberFormatter.string(from: NSNumber(value: dataSource.statistics.meanCompletionPercentage))!
                cell.detailTextLabel?.text = String.localizedStringWithFormat("SctDetail.TableCell.Detail.MeanCompletionPerentage".localized, meanCompletionPercentage)
                
            // resume
            case .resume:
                cell.textLabel?.text = "SctDetail.TableCell.Resume".localized
                cell.textLabel?.textColor = Appearance.Color.action
                
            // launch
            case .launch:
                cell.textLabel?.text = "SctDetail.TableCell.Launch".localized
                cell.textLabel?.textColor = Appearance.Color.action
            }
            return cell
        }
    }
    
    weak var delegate: SctDetailViewDelegate? = nil
    weak var dataSource: SctDetailViewDataSource? = nil {
        didSet {
            reloadData()
        }
    }
    fileprivate var sections_: [SctDetailSection] {
        return dataSource?.sections ?? []
    }
    fileprivate func rows_(for section: SctDetailSection, at index: Int) -> [SctDetailRow]
    {
        return dataSource?.rows(for: section, at: index) ?? []
    }
    fileprivate weak var tableView_: UITableView!
    fileprivate var performRateCell_: SctPerformRateCell? = nil
    fileprivate var removeRateIndex_: IndexPath? = nil
    
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
        tableView.registerNibCell(SctRateCell.self)
        tableView.registerNibCell(SctPerformRateCell.self)
        tableView.registerNibCell(SctUpdateRateCell.self)
        tableView.registerNibCell(SctScoreDiagramCell.self)
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
        let currentSection = sections_[indexPath.section]
        let currentRow = rows_(for: currentSection, at: indexPath.section)[indexPath.row]
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        // perform rate
        if selectedCell == performRateCell_
        {
            if !(performRateCell_?.isDisplayingStars ?? true)
            {
                return indexPath
            }
            performRateCell_?.cancelVote()
        }
        else if (performRateCell_?.isDisplayingStars ?? false)
        {
            performRateCell_?.cancelVote()
        }
            
        // remove rate
        if removeRateIndex_ == indexPath
        {
            return indexPath
        }
        
        // other
        switch currentRow
        {
        case .resume, .launch:
            return indexPath
        default:
            break
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let currentSection = sections_[indexPath.section]
        let currentRow = rows_(for: currentSection, at: indexPath.section)[indexPath.row]
        
        let selectedCell = tableView.cellForRow(at: indexPath)
        if selectedCell == performRateCell_
        {
            performRateCell_?.displayStars()
        }
        else if removeRateIndex_ == indexPath
        {
            delegate?.sctDetailView(didRemoveVote: self)
        }
        
        // other
        switch currentRow
        {
        case .resume:
            delegate?.sctDetailView(didResume: self)
        case .launch:
            delegate?.sctDetailView(didLaunch: self)
        default:
            break
        }
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
        let currentRows = rows_(for: currentSection, at: section)
        return currentRows.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let currentSection = sections_[section]
        return currentSection.headerTitle
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = sections_[indexPath.section]
        let currentRows = rows_(for: section, at: indexPath.section)
        let row = currentRows[indexPath.row]
        
        return row.cell(for: indexPath, sctDetailViewController: self)
    }
}

// -----------------------------------------------------------------------------
// MARK: - SCT PERFORM RATE CELL DELEGATE
// -----------------------------------------------------------------------------
extension SctDetailViewController: SctPerformRateCellDelegate
{
    func sctPerformRateCell(didCancelPerformRate sctPerformRateCell: SctPerformRateCell)
    {
    }
    
    func sctPerformRateCell(_ sctPerformRateCell: SctPerformRateCell, didChooseRate rate: Int)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.delegate?.sctDetailView(self, didPerformVote: rate)
        })
    }
}

// -----------------------------------------------------------------------------
// MARK: - SCT UPDATE RATE CELL DELEGATE
// -----------------------------------------------------------------------------
extension SctDetailViewController: SctUpdateRateCellDelegate
{
    func sctUpdateRateCell(_ sctUpdateRateCell: SctUpdateRateCell, didChooseRate rate: Int)
    {
        delegate?.sctDetailView(self, didUpdateVote: rate)
    }
}
