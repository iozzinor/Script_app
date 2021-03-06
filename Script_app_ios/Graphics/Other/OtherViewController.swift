//
//  OtherViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 01/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class OtherViewController: UITableViewController
{
    static let toWalkthroughs           = "OtherToWalkthroughsSegueId"
    static let toLeaderboard            = "OtherToLeaderboardSegueId"
    
    static let otherCellIdentifier = "OtherCellReuseId"
    
    // -------------------------------------------------------------------------
    // MARK: - ROWS
    // -------------------------------------------------------------------------
    enum OtherRow: Int, CaseIterable
    {
        case walkthroughs
        case leaderboard
        
        var title: String {
            switch self
            {
            case .walkthroughs:
                return "OtherViewController.Tutorials".localized
            case .leaderboard:
                return "OtherViewController.Leaderboard".localized
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        navigationItem.title = "OtherViewController.NavigationItem.Title".localized
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUES
    // -------------------------------------------------------------------------
    fileprivate func displayWalkthroughs_()
    {
        performSegue(withIdentifier: OtherViewController.toWalkthroughs, sender: self)
    }
    
    fileprivate func displayLeaderboard_()
    {
        performSegue(withIdentifier: OtherViewController.toLeaderboard, sender: self)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DELEGATE
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let row = OtherRow.allCases[indexPath.row]
        
        switch row
        {
        case .leaderboard:
            displayLeaderboard_()
        case .walkthroughs:
            displayWalkthroughs_()
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DATA SOURCE
    // -------------------------------------------------------------------------
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return OtherRow.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: OtherViewController.otherCellIdentifier, for: indexPath)
        let row = OtherRow.allCases[indexPath.row]
        
        cell.accessoryType = .none
        cell.textLabel?.text = row.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
