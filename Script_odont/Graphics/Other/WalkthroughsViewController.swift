//
//  WalkthroughsViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 08/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class WalkthroughsViewController: UITableViewController
{
    static let cellId = "WalkthroughsCellReuseId"
    static let toWalkthroughSegueId = "WalkthroughsToWalkthroughSegueId"
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDelegate
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: WalkthroughsViewController.toWalkthroughSegueId, sender: self)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: WalkthroughsViewController.cellId, for: indexPath)
        cell.textLabel?.text = "Walkthroughs.Show.Welcome".localized
        
        return cell
    }
}
