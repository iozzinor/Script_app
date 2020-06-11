//
//  SctsUnfinishedListViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 17/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SctsUnfinishedListViewController: UITableViewController
{
    static let toSctUnfinished = "SctsUnfinishedListToSctUnfinishedSegueId"
    
    var unfinishedScts = [SctUnfinished]()
    {
        didSet
        {
            if isViewLoaded
            {
                tableView.reloadData()
            }
        }
    }
    fileprivate var unfinishedSctIndex_ = 0
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupTableView_()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        navigationItem.title = "SctsUnfinishedList.NavigationItem.Title".localized
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setupTableView_()
    {
        tableView.registerNibCell(MySctUnfinishedCell.self)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUES
    // -------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == SctsUnfinishedListViewController.toSctUnfinished,
            let target = segue.destination as? SctUnfinishedViewController
        {
            let unfinishedSct = unfinishedScts[unfinishedSctIndex_]
            target.sctUnfinished = unfinishedSct
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DELEGATE
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        unfinishedSctIndex_ = indexPath.row
        performSegue(withIdentifier: SctsUnfinishedListViewController.toSctUnfinished, sender: self)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DATE SOURCE
    // -------------------------------------------------------------------------
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return unfinishedScts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let unfinished = unfinishedScts[indexPath.row]
        let cell = tableView.dequeueReusableCell(for: indexPath) as MySctUnfinishedCell
        cell.setSctUnfinished(unfinished)
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}
