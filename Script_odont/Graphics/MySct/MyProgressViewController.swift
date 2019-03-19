//
//  MyProgressViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 18/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class MyProgressViewController: UITableViewController
{
    // -------------------------------------------------------------------------
    // MARK: - PROGRESS SECTION
    // -------------------------------------------------------------------------
    fileprivate enum ProgressSection
    {
        case diagram
        case data
        case explanation
        
        var headerTitle: String?
        {
            switch self
            {
            case .diagram, .explanation:
                return nil
            case .data:
                return "MyProgress.Section.Data.Title".localized
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - PROGRESS ROW
    // -------------------------------------------------------------------------
    fileprivate enum ProgressRow
    {
        case diagram
        
        case noProgression
        case dataCount(Int)
        case meanScore(Double)
        case answeredSctExams(Int)
        
        case explanation
        
        var accessoryType: UITableViewCell.AccessoryType
        {
            return .none
        }
        
        var selectionStyle: UITableViewCell.SelectionStyle
        {
            return .none
        }
        
        func cell(for indexPath: IndexPath, tableView: UITableView, myProgressViewController: MyProgressViewController) -> UITableViewCell
        {
            switch self
            {
            case .diagram:
                let cell = tableView.dequeueReusableCell(for: indexPath) as ProgressCell
                cell.delegate = myProgressViewController
                cell.scoreProgressDiagram.dataSource = myProgressViewController
                myProgressViewController.scoreProgressDiagram_ = cell.scoreProgressDiagram
                return cell
                
            case .noProgression:
                let cell = tableView.dequeueReusableCell(withIdentifier: MyProgressViewController.explanationCellId, for: indexPath)
                cell.textLabel?.text = "MyProgress.NoProgression".localized
                cell.textLabel?.textColor = Appearance.Color.missing
                return cell
            case let .dataCount(dataCount):
                let cell = tableView.dequeueReusableCell(withIdentifier: MyProgressViewController.informationCellId, for: indexPath)
                cell.textLabel?.text = "MyProgress.Data.Count.Title".localized
                cell.detailTextLabel?.text = "\(dataCount)"
                return cell
            case let .meanScore(meanScore):
                let cell = tableView.dequeueReusableCell(withIdentifier: MyProgressViewController.informationCellId, for: indexPath)
                cell.textLabel?.text = "MyProgress.Data.MeanScore.Title".localized
                cell.detailTextLabel?.text = Constants.formatReal(meanScore)
                return cell
            case let .answeredSctExams(answeredSctsExams):
                let cell = tableView.dequeueReusableCell(withIdentifier: MyProgressViewController.informationCellId, for: indexPath)
                cell.textLabel?.text = "MyProgress.Data.AnsweredSctExams.Title".localized
                cell.detailTextLabel?.text = "\(answeredSctsExams)"
                return cell
                
            case .explanation:
                let cell = tableView.dequeueReusableCell(withIdentifier: MyProgressViewController.explanationCellId, for: indexPath)
                cell.textLabel?.text = "MyProgress.Explanation".localized
                cell.textLabel?.textColor = Appearance.Color.default
                return cell
            }
        }
    }
    
    public static let informationCellId = "MyProgressInformationCellReuseId"
    public static let explanationCellId = "MyProgressExplanationCellReuseId"
    
    fileprivate static let hourDateFormatter_: DateFormatter = {
        let result = DateFormatter()
        
        if Constants.isTwelveHourDateFormat
        {
            result.dateFormat = "h"
        }
        else
        {
            result.dateFormat = "H"
        }
        
        return result
    }()
    
    fileprivate var sections_: [(section: ProgressSection, rows: [ProgressRow])] {
        var result = [(section: ProgressSection, rows: [ProgressRow])]()
        
        // diagram
        result.append((section: .diagram, rows: [.diagram]))
        
        // data
        if let progression = progression_
        {
            result.append((section: .data, rows: [.dataCount(progression.scores.count),
                                                  .meanScore(progression.meanScore),
                                                  .answeredSctExams(progression.answeredSctExams)]))
        }
        else
        {
            result.append((section: .data, rows: [.noProgression]))
        }
        
        // explanation
        result.append((section: .explanation, rows: [.explanation]))
        
        return result
    }
    
    fileprivate var progression_: Progression? = nil
    {
        didSet
        {
            var sectionsToReload = [Int]()
            for (i, currentSection) in sections_.enumerated()
            {
                switch currentSection.section
                {
                case .diagram, .explanation:
                    continue
                case .data:
                    sectionsToReload.append(i)
                }
            }
            
            if !sectionsToReload.isEmpty
            {
                tableView.reloadSections(IndexSet(sectionsToReload), with: .automatic)
            }
            
            scoreProgressDiagram_?.reloadData()
        }
    }
    
    fileprivate weak var scoreProgressDiagram_: ScoreProgressDiagram?
    fileprivate var currentPeriod_ = Period.day
    
    fileprivate var todayHours_: [Date] = {
        var result = [Date]()
        
        let currentDate = Date()
        var components = Calendar.current.dateComponents(Set([Calendar.Component.day, .month, .year, .hour]), from: currentDate)
        components.minute = 0
        components.second = 0
        
        for i in 0..<8
        {
            components.hour = i * 3
            
            if let date = Calendar.current.date(from: components)
            {
                result.append(date)
            }
        }
        
        return result
    }()
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        navigationItem.title = "MyProgress.NavigationItem.Title".localized
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DATA SOURCE
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return sections_[section].section.headerTitle
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return sections_.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sections_[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = sections_[indexPath.section]
        let row = section.rows[indexPath.row]
        
        let cell = row.cell(for: indexPath, tableView: tableView, myProgressViewController: self)
        
        cell.accessoryType = row.accessoryType
        cell.selectionStyle = row.selectionStyle
        
        return cell
    }
}

// -------------------------------------------------------------------------
// MARK: - PROGRESS CELL DELEGATE
// -------------------------------------------------------------------------
extension MyProgressViewController: ProgressCellDelegate
{
    func progressCell(_ progressCell: ProgressCell, didChoosePeriod period: Period)
    {
        currentPeriod_ = period
        
        // MARK: - TEMP
        // add random progress
        if Constants.random(min: 0, max: 1) == 0
        {
            progression_ = nil
        }
        else
        {
            var scores = [Double]()
            for _ in 0..<Constants.random(min: 2, max: 20)
            {
                scores.append(Double(Constants.random(min: 0, max: 1000)) / 10.0)
            }
            progression_ = Progression(time: 0,
                                       meanScore: Double(Constants.random(min: 0, max: 1000)) / 10.0,
                                       answeredSctExams: Constants.random(min: 10, max: 30),
                                       scores: scores)
        }
    }
}

// -------------------------------------------------------------------------
// MARK: - SCORE PROGRESS DIAGRAM DATA SOURCE
// -------------------------------------------------------------------------
extension MyProgressViewController: ScoreProgressDiagramDataSource
{
    func numberOfHorizontalSeparations(in scoreProgressDiagram: ScoreProgressDiagram) -> Int
    {
        return 10
    }
    
    func scoreProgressDiagram(_ scoreProgressDiagram: ScoreProgressDiagram, titleForHorizontalSeparation horizontalSeparationIndex: Int) -> String?
    {
        let percentage = (horizontalSeparationIndex + 1) * 10
        return String.localizedStringWithFormat("MyProgress.OrdinatesAxis.Legend".localized, percentage)
    }
    
    func ordinatesAxisTitle(for scoreProgressDiagram: ScoreProgressDiagram) -> String
    {
        return "MyProgress.OrdinatesAxis.Title".localized
    }
    
    func numberOfSections(in scoreProgressDiagram: ScoreProgressDiagram) -> Int
    {
        switch currentPeriod_
        {
        case .day:
            return todayHours_.count
        case .week:
            return Constants.dayNames.count
        case .month:
            return Int(ceil(Double(Constants.daysInCurrentMonth) / 7))
        case .year:
            return Constants.monthNames.count
        }
    }
    
    func scoreProgressDiagram(_ scoreProgressDiagram: ScoreProgressDiagram, titleForSection section: Int) -> String?
    {
        switch currentPeriod_
        {
        case .day:
            let hourDate = todayHours_[section]
            return MyProgressViewController.hourDateFormatter_.string(from: hourDate)
        case .week:
            return Constants.dayNames[section]
        case .month:
            return "\(section * 7 + 1)"
        case .year:
            let uppercaseMonth = Constants.monthNames[section].uppercased()
            let firstLetter = uppercaseMonth[uppercaseMonth.startIndex..<uppercaseMonth.index(after: uppercaseMonth.startIndex)]
            return String(firstLetter)
        }
    }
    
    func numberOfSubsections(in scoreProgressDiagram: ScoreProgressDiagram) -> Int
    {
        switch currentPeriod_
        {
        case .day:
            return 2
        case .week, .month, .year:
            return 0
        }
    }
    
    func numberOfScores(for scoreProgressDiagram: ScoreProgressDiagram) -> Int
    {
        return progression_?.scores.count ?? 0
    }
    
    func scoreProgressDiagram(_ scoreProgressDiagram: ScoreProgressDiagram, scoreForTime time: Int) -> ScoreProgressDiagram.ScorePoint
    {
        let timeCount = progression_?.scores.count ?? 1
        let score = progression_?.scores[time] ?? 0.0
        let time = Double(time + 1) * (100.0) / Double(timeCount + 1)
        
        return ScoreProgressDiagram.ScorePoint(score: score, time: time)
    }
}
