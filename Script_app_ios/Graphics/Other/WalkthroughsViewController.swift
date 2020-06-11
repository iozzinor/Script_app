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
    
    static let toWelcomeWalkthrough         = "WalkthroughsToWelcomeWalkthroughSegueId"
    static let toDrawingWalkthrough         = "WalkthroughsToDrawingWalkthroughSegueId"
    static let toDrawingExampleWalkthrough  = "WalkthroughsToDrawingExampleWalkthroughSegueId"
    static let toSctTypeWalkthrough         = "WalkthroughsToSctTypeWalkthroughSegueId"
    
    // -------------------------------------------------------------------------
    // MARK: - ROW
    // -------------------------------------------------------------------------
    fileprivate enum WalkthroughRow
    {
        case welcome
        case drawing
        case drawingExample
        case sctType
        
        var title: String
        {
            switch self
            {
            case .welcome:
                return "Walkthroughs.Show.Welcome".localized
            case .drawing:
                return "Walkthroughs.Show.Drawing".localized
            case .drawingExample:
                return "Walkthroughs.Show.DrawingExample".localized
            case .sctType:
                return "Walkthroughs.Show.SctType".localized
            }
        }
    }
    
    fileprivate var rows_: [WalkthroughRow] = [.welcome, .drawing, .drawingExample, .sctType]
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DELEGATE
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let row = rows_[indexPath.row]
        
        switch row
        {
        case .welcome:
            performSegue(withIdentifier: WalkthroughsViewController.toWelcomeWalkthrough, sender: self)
        case .drawing:
            performSegue(withIdentifier: WalkthroughsViewController.toDrawingWalkthrough, sender: self)
        case .drawingExample:
            performSegue(withIdentifier: WalkthroughsViewController.toDrawingExampleWalkthrough, sender: self)
        case .sctType:
            performSegue(withIdentifier: WalkthroughsViewController.toSctTypeWalkthrough, sender: self)
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
        return rows_.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let row = rows_[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WalkthroughsViewController.cellId, for: indexPath)
        cell.textLabel?.text = row.title
        
        return cell
    }
}
