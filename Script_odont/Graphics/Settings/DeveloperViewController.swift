//
//  DeveloperViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 25/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

// -----------------------------------------------------------------------------
// MARK: - DEVELOPER SETTINGS SECTION
// -----------------------------------------------------------------------------
enum DeveloperSection: TableSection
{
    case server
    
    var headerTitle: String? {
        switch self
        {
        case .server:
            return "Developer.Section.Server.Title".localized
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - DEVELOPER SETTINGS ROW
// -----------------------------------------------------------------------------
enum DeveloperRow: TableRow
{
    typealias ViewController = UIViewController
    
    // server
    case serverName
    case serverPort
    
    var accessoryType: UITableViewCell.AccessoryType {
        return .none
    }
    
    var selectionStyle: UITableViewCell.SelectionStyle {
        return .none
    }
    
    func cell(for indexPath: IndexPath, tableView: UITableView, viewController: UIViewController) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: DeveloperViewController.detailCellId, for: indexPath)
        switch self
        {
        case .serverName:
            cell.textLabel?.text = "Developer.Row.ServerName".localized
            cell.detailTextLabel?.text = Settings.shared.serverName
        case .serverPort:
            cell.textLabel?.text = "Developer.Row.ServerPort".localized
            cell.detailTextLabel?.text = "\(Settings.shared.serverPort)"
        }
        
        return cell
    }
}



class DeveloperViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    public static let detailCellId = "DeveloperDetailCellReuseId"
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var sections_: [(section: DeveloperSection, rows: [DeveloperRow])] {
        var result = [(section: DeveloperSection, rows: [DeveloperRow])]()
        
        result.append((section: .server, rows: [.serverName, .serverPort]))
        
        return result
    }
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setup_()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Developer.NavigationItem.Title".localized
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setup_()
    {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DELEGATE
    // -------------------------------------------------------------------------
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DATA SOURCE
    // -------------------------------------------------------------------------
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return sections_.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sections_[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let row = sections_[indexPath.section].rows[indexPath.row]
        
        let cell = row.cell(for: indexPath, tableView: tableView, viewController: self)
        cell.accessoryType = row.accessoryType
        cell.selectionStyle = row.selectionStyle
        
        return cell
    }
}
