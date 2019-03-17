//
//  PeriodLeaderboardViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 17/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

extension LatestPeriod
{
    fileprivate var navigationItemTitle_: String
    {
        switch self
        {
        case .day:
            return "PeriodLeaderboard.NavigationItemTitle.Day".localized
        case .week:
            return "PeriodLeaderboard.NavigationItemTitle.Week".localized
        case .month:
            return "PeriodLeaderboard.NavigationItemTitle.Month".localized
        case .year:
            return "PeriodLeaderboard.NavigationItemTitle.Year".localized
        }
    }
}

class PeriodLeaderboardViewController: LeaderboardViewController
{
    var period: LatestPeriod = .day
    {
        didSet
        {
            if isViewLoaded
            {
                updateUiPeriod_()
                tableView.reloadData()
            }
        }
    }
    
    override var sections_: [(section: LeaderboardViewController.LeaderboardSection, rows: [LeaderboardViewController.LeaderboardRow])]
    {
        var result = [(section: LeaderboardViewController.LeaderboardSection, rows: [LeaderboardViewController.LeaderboardRow])]()
        
        // top ten
        result.append((section: .topTen, rows: bestTenUsers_.map { LeaderboardRow.foreignCandidate($0)} ))
        
        // user
        result.append((section: .user, rows: [.foreignCandidate(userStatistics_)]))
    
        return result
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUiPeriod_()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UPDATE UI
    // -------------------------------------------------------------------------
    fileprivate func updateUiPeriod_()
    {
        navigationItem.title = period.navigationItemTitle_
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let result = super.tableView(tableView, cellForRowAt: indexPath)
        
        let section = sections_[indexPath.section].section
        switch section
        {
        case .user:
            if let cell = result as? CandidateStatisticsCell
            {
                cell.userNameLabel.isHidden = true
            }
        case .periods, .topTen:
            break
        }
        
        return result
    }
}
