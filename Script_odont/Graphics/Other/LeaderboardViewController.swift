//
//  LeaderboardViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 17/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

fileprivate func defaultForeignCandidates_() -> [CandidateStatistics]
{
    var result = [CandidateStatistics]()
    
    for i in 0..<10
    {
        let newCandidateStatistics = CandidateStatistics(name: "Candidate \(i + 1)",
            rank: i + 1,
            answeredSctExams: Constants.random(min: 100, max: 1000),
            meanScore: Double(Constants.random(min: 500, max: 1000)) / 10.0)
        result.append(newCandidateStatistics)
    }
    
    return result
}

class LeaderboardViewController: UITableViewController
{
    // -------------------------------------------------------------------------
    // MARK: - LEADERBOARD SECTION
    // -------------------------------------------------------------------------
    enum LeaderboardSection
    {
        case periods
        
        case topTen
        
        case user
        
        var headerTitle: String?
        {
            switch self
            {
            case .periods:
                return nil
            case .topTen:
                return "Leaderboard.Section.TopTen.Title".localized
            case .user:
                return "Leaderboard.Section.User.Title".localized
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - LEADERBOARD ROW
    // -------------------------------------------------------------------------
    enum LeaderboardRow
    {
        case period(LatestPeriod)
        
        case foreignCandidate(CandidateStatistics)
        
        case userRank(Int)
        case userAnsweredSctExams(Int)
        case userMeanScore(Double)
        
        func cell(for indexPath: IndexPath, tableView: UITableView, leaderboardViewController: LeaderboardViewController) -> UITableViewCell
        {
            switch self
            {
            // period
            case let .period(latestPeriod):
                let cell = tableView.dequeueReusableCell(withIdentifier: LeaderboardViewController.periodCellId, for: indexPath)
                cell.textLabel?.text = latestPeriod.name
                return cell
                
            // foreign candidate
            case let .foreignCandidate(candidateStatistics):
                let cell = tableView.dequeueReusableCell(for: indexPath) as CandidateStatisticsCell
                cell.setStatistics(candidateStatistics)
                return cell
                
            // user
            case let .userRank(rank):
                let cell = tableView.dequeueReusableCell(withIdentifier: LeaderboardViewController.userCellId, for: indexPath)
                cell.textLabel?.text = "Leaderboard.User.Rank".localized
                cell.detailTextLabel?.text = "\(rank)"
                return cell
            case let .userAnsweredSctExams(answeredSctExams):
                let cell = tableView.dequeueReusableCell(withIdentifier: LeaderboardViewController.userCellId, for: indexPath)
                cell.textLabel?.text = "Leaderboard.User.AnsweredSctExams".localized
                cell.detailTextLabel?.text = "\(answeredSctExams)"
                return cell
            case let .userMeanScore(meanScore):
                let cell = tableView.dequeueReusableCell(withIdentifier: LeaderboardViewController.userCellId, for: indexPath)
                cell.textLabel?.text = "Leaderboard.User.MeanScore".localized
                cell.detailTextLabel?.text = Constants.formatReal(meanScore)
                return cell
            }
        }
        
        var accessoryType: UITableViewCell.AccessoryType
        {
            switch self
            {
            case .period(_):
                return .disclosureIndicator
            case .foreignCandidate(_), .userRank(_), .userAnsweredSctExams(_), .userMeanScore(_):
                return .none
            }
        }
        
        var selectionStyle: UITableViewCell.SelectionStyle
        {
            return .none
        }
    }
    
    static let toPeriodLeaderboardSegueId = "LeaderboardToPeriodLeaderboardSegueId"
    
    static let periodCellId = "LeaderboardPeriodCellReuseId"
    static let userCellId   = "LeaderboardUserCellReuseId"
    
    fileprivate var currentPeriod_ = LatestPeriod.day
    
    var bestTenUsers_: [CandidateStatistics] = defaultForeignCandidates_()
    var userStatistics_ = CandidateStatistics(name: "", rank: 100, answeredSctExams: 1000, meanScore: 75.0)
    
    var sections_: [(section: LeaderboardSection, rows: [LeaderboardRow])]
    {
        var result = [(section: LeaderboardSection, rows: [LeaderboardRow])]()
        
        // period
        result.append((section: .periods, rows: LatestPeriod.allCases.map { LeaderboardRow.period($0) }))
        
        // top ten
        result.append((section: .topTen, rows: bestTenUsers_.map { LeaderboardRow.foreignCandidate($0)} ))
        
        // user
        var userRows = [LeaderboardRow]()
        userRows.append(.userRank(userStatistics_.rank))
        userRows.append(.userAnsweredSctExams(userStatistics_.answeredSctExams))
        userRows.append(.userMeanScore(userStatistics_.meanScore))
        result.append((section: .user, rows: userRows))
        
        return result
    }
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.registerNibCell(CandidateStatisticsCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Leaderboard.NavigationItem.Title".localized
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUES
    // -------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == LeaderboardViewController.toPeriodLeaderboardSegueId,
            let target = segue.destination as? PeriodLeaderboardViewController
        {
            target.period = currentPeriod_
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DELEGATE
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        let row = sections_[indexPath.section].rows[indexPath.row]
        
        switch row
        {
        case .period(_):
            return indexPath
        case .foreignCandidate(_), .userRank(_), .userAnsweredSctExams(_), .userMeanScore(_):
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let row = sections_[indexPath.section].rows[indexPath.row]
        
        switch row
        {
        case let .period(latestPeriod):
            currentPeriod_ = latestPeriod
            performSegue(withIdentifier: LeaderboardViewController.toPeriodLeaderboardSegueId, sender: self)
        case .foreignCandidate(_), .userRank(_), .userAnsweredSctExams(_), .userMeanScore(_):
            break
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DATASOURCE
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
        let row = sections_[indexPath.section].rows[indexPath.row]
        let cell = row.cell(for: indexPath, tableView: tableView, leaderboardViewController: self)
        
        cell.accessoryType = row.accessoryType
        cell.selectionStyle = row.selectionStyle
        return cell
    }
}
