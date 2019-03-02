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
    static let otherCellIdentifier = "OtherCellReuseId"
    static let toWalkthrough = "OtherToWalkthroughSegueId"
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUES
    // -------------------------------------------------------------------------
    fileprivate func displayWalkthrough_()
    {
        performSegue(withIdentifier: OtherViewController.toWalkthrough, sender: self)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDelegate
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        displayWalkthrough_()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDataSource
    // -------------------------------------------------------------------------
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: OtherViewController.otherCellIdentifier, for: indexPath)
        cell.accessoryType = .none
        cell.textLabel?.text = "OtherViewController.ShowTutorial".localized
        return cell
    }
}
