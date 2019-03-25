//
//  AdvancedSettingsViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 25/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

// -----------------------------------------------------------------------------
// MARK: - ADVANCED SETTINGS SECTION
// -----------------------------------------------------------------------------
enum AdvancedSettingsSection: TableSection
{
    case general
    
    var headerTitle: String? {
        return nil
    }
}

// -----------------------------------------------------------------------------
// MARK: - ADVANCED SETTINGS ROW
// -----------------------------------------------------------------------------
enum AdvancedSettingsRow: TableRow
{
    typealias ViewController = UIViewController
    
    case developer
    
    var accessoryType: UITableViewCell.AccessoryType {
        return .none
    }
    
    var selectionStyle: UITableViewCell.SelectionStyle {
        return .none
    }
    
    func cell(for indexPath: IndexPath, tableView: UITableView, viewController: UIViewController) -> UITableViewCell
    {
        let advancedSettingsViewController = viewController as? AdvancedSettingsViewController
        
        switch self
        {
        case .developer:
            let result = tableView.dequeueReusableCell(for: indexPath) as SwitchCell
            result.label.text = "AdvancedSettings.Row.Developer".localized
            result.switchControl.isOn = Settings.shared.showDeveloper
            result.delegate = advancedSettingsViewController
            return result
        }
    }
}


class AdvancedSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var sections_: [(section: AdvancedSettingsSection, rows: [AdvancedSettingsRow])] {
        var result = [(section: AdvancedSettingsSection, rows: [AdvancedSettingsRow])]()
        
        result.append((section: .general, rows: [.developer]))
        
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
        
        navigationItem.title = "AdvancedSettings.NavigationItem.Title".localized
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setup_()
    {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNibCell(SwitchCell.self)
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

// -------------------------------------------------------------------------
// MARK: - SWITCH CELL DELEGATE
// -------------------------------------------------------------------------
extension AdvancedSettingsViewController: SwitchCellDelegate
{
    func switchCell(_ switchCell: SwitchCell, didSelectValue value: Bool)
    {
        Settings.shared.showDeveloper = value
    }
}
