//
//  SctsFinishedListViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 17/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SctsFinishedListViewController: UITableViewController
{
    static let toSctFinished = "SctsFinishedListToSctFinishedSegueId"
    
    var finishedScts = [SctFinished]()
    {
        didSet
        {
            if isViewLoaded
            {
                tableView.reloadData()
            }
        }
    }
    
    fileprivate var finishedSctIndex_ = 0
    
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
        
        navigationItem.title = "SctsFinishedList.NavigationItem.Title".localized
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setupTableView_()
    {
        tableView.registerNibCell(MySctFinishedCell.self)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUES
    // -------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == SctsFinishedListViewController.toSctFinished,
            let target = segue.destination as? SctFinishedViewController
        {
            let sctFinished = finishedScts[finishedSctIndex_]
            target.setSctFinished(sctFinished)
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DELEGATE
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        finishedSctIndex_ = indexPath.row
        performSegue(withIdentifier: SctsFinishedListViewController.toSctFinished, sender: self)
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
        return finishedScts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let finished = finishedScts[indexPath.row]
        let cell = tableView.dequeueReusableCell(for: indexPath) as MySctFinishedCell
        cell.setSctFinished(finished)
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}
