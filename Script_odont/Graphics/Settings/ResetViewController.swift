//
//  ResetViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 25/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

// -----------------------------------------------------------------------------
// MARK: - RESET SETTINGS SECTION
// -----------------------------------------------------------------------------
enum ResetSection: TableSection
{
    case general
    
    var headerTitle: String? {
        return nil
    }
}

// -----------------------------------------------------------------------------
// MARK: - RESET SETTINGS ROW
// -----------------------------------------------------------------------------
enum ResetRow: TableRow
{
    typealias ViewController = UIViewController
    
    case settings
    case data
    
    var accessoryType: UITableViewCell.AccessoryType {
        return .none
    }
    
    var selectionStyle: UITableViewCell.SelectionStyle {
        return .none
    }
    
    func cell(for indexPath: IndexPath, tableView: UITableView, viewController: UIViewController) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: ResetViewController.detailCellId, for: indexPath)
        
        let canResetSettings = !Settings.shared.isDefault
        
        switch self
        {
        case .settings:
            cell.textLabel?.text = "Reset.Row.Settings".localized
            cell.textLabel?.textColor = canResetSettings ? Appearance.Color.action : Appearance.Color.missing
        case .data:
            cell.textLabel?.text = "Reset.Row.Data".localized
            cell.textLabel?.textColor = Appearance.Color.missing
        }
        return cell
    }
}


class ResetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    public static let detailCellId = "ResetDetailCellReuseId"
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var sections_: [(section: ResetSection, rows: [ResetRow])] {
        var result = [(section: ResetSection, rows: [ResetRow])]()
        
        result.append((section: .general, rows: [.settings, .data]))
        
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
        
        navigationItem.title = "Reset.NavigationItem.Title".localized
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
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        let row = sections_[indexPath.section].rows[indexPath.row]
        
        switch row
        {
        case .settings:
            return Settings.shared.isDefault ? nil : indexPath
        case .data:
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let row = sections_[indexPath.section].rows[indexPath.row]
        
        switch row
        {
        case .settings:
            confirmResetParameters_()
        case .data:
            break
        }
    }
    
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
    
    // -------------------------------------------------------------------------
    // MARK: - RESET PARAMETERS
    // -------------------------------------------------------------------------
    fileprivate func confirmResetParameters_()
    {
        let confirmController = UIAlertController(title: "Reset.Parameters.Confirm.Alert.Title".localized, message: "Reset.Parameters.Confirm.Alert.Message".localized, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Common.Yes".localized, style: .destructive, handler: {
            (_) -> Void in
            
            self.resetParameters_()
        })
        let noAction = UIAlertAction(title: "Common.No".localized, style: .cancel, handler: nil)
        confirmController.addAction(yesAction)
        confirmController.addAction(noAction)
        
        present(confirmController, animated: true, completion: nil)
    }
    
    fileprivate func resetParameters_()
    {
        Settings.shared.reset()
        
        let resettedController = UIAlertController(title: "Reset.Parameters.Alert.Title".localized, message: "Reset.Parameters.Alert.Message".localized, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Common.Ok".localized, style: .cancel, handler: nil)
        resettedController.addAction(okAction)
        
        present(resettedController, animated: true, completion: {
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        })
    }
}
