//
//  AboutViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 25/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

// -----------------------------------------------------------------------------
// MARK: - ABOUT SETTINGS SECTION
// -----------------------------------------------------------------------------
enum AboutSection: TableSection
{
    case general
    
    var headerTitle: String? {
        return nil
    }
}

// -----------------------------------------------------------------------------
// MARK: - ABOUT SETTINGS ROW
// -----------------------------------------------------------------------------
enum AboutRow: TableRow
{
    typealias ViewController = UIViewController
    
    case applicationVersion
    case applicationBuild
    
    var accessoryType: UITableViewCell.AccessoryType {
        return .none
    }
    
    var selectionStyle: UITableViewCell.SelectionStyle {
        return .none
    }
    
    func cell(for indexPath: IndexPath, tableView: UITableView, viewController: UIViewController) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: AboutViewController.detailCellId, for: indexPath)
        
        switch self
        {
        case .applicationVersion:
            cell.textLabel?.text = "About.Row.ApplicationVersion".localized
            cell.detailTextLabel?.text = UIApplication.applicationVersion
        case .applicationBuild:
            cell.textLabel?.text = "About.Row.ApplicationBuild".localized
            cell.detailTextLabel?.text = UIApplication.applicationBuild
        }
        return cell
    }
}


class AboutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    public static let detailCellId = "AboutDetailCellReuseId"
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var sections_: [(section: AboutSection, rows: [AboutRow])] {
        var result = [(section: AboutSection, rows: [AboutRow])]()
        
        result.append((section: .general, rows: [.applicationVersion, .applicationBuild]))
        
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
        
        navigationItem.title = "About.NavigationItem.Title".localized
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
