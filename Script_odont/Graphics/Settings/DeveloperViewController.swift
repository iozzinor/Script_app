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
    fileprivate var actionToEnable: UIAlertAction?
    
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
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        let row = sections_[indexPath.section].rows[indexPath.row]
        switch row
        {
        case .serverName, .serverPort:
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let row = sections_[indexPath.section].rows[indexPath.row]
        switch row
        {
        case .serverName:
            getServerName_()
        case .serverPort:
            getServerPort_()
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DATA SOURCE
    // -------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return sections_[section].section.headerTitle
    }
    
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
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    fileprivate func getServerName_()
    {
        let alertController = UIAlertController(title: "Developer.ServerName.Alert.Title".localized, message: "Developer.ServerName.Alert.Message".localized, preferredStyle: .alert)
        
        // text fields
        var newTextField: UITextField?
        alertController.addTextField(configurationHandler: {
            $0.placeholder = "Developer.ServerName.TextField.Placeholder".localized
            $0.text = Settings.shared.serverName
            newTextField = $0
            
            $0.addTarget(self, action: #selector(DeveloperViewController.serverNameChanged_), for: .editingChanged)
        })
        
        // actions
        let okAction = UIAlertAction(title: "Common.Ok".localized, style: .default, handler: {
            (_) -> Void in
            
            if let textField = alertController.textFields?.first,
                let newServerName = textField.text
            {
                Settings.shared.serverName = newServerName
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        })
        let cancelAction = UIAlertAction(title: "Common.Cancel".localized, style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        okAction.isEnabled = false
        actionToEnable = okAction
        
        present(alertController, animated: true, completion: {
            newTextField?.becomeFirstResponder()
            newTextField?.selectAll(nil)
        })
    }
    
    @objc fileprivate func serverNameChanged_(_ sender: UITextField)
    {
        self.actionToEnable?.isEnabled = !(sender.text?.isEmpty ?? true)
    }
    
    fileprivate func getServerPort_()
    {
        let alertController = UIAlertController(title: "Developer.ServerPort.Alert.Title".localized, message: "Developer.ServerPort.Alert.Message".localized, preferredStyle: .alert)
        
        // text fields
        alertController.addTextField(configurationHandler: {
            $0.placeholder = "Developer.ServerPort.TextField.Placeholder".localized
            
            $0.addTarget(self, action: #selector(DeveloperViewController.serverPortChanged_), for: .editingChanged)
        })
        
        // actions
        let okAction = UIAlertAction(title: "Common.Ok".localized, style: .default, handler:  {
            (_) -> Void in
            
            if let textField = alertController.textFields?.first,
                let newServerPortString = textField.text,
                let newServerPort = Int(newServerPortString)
            {
                Settings.shared.serverPort = newServerPort
                self.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            }
        })
        let cancelAction = UIAlertAction(title: "Common.Cancel".localized, style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        okAction.isEnabled = false
        actionToEnable = okAction
        
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func isServerPortStringValid_(_ serverPort: String) -> Bool
    {
        if serverPort.isEmpty
        {
            return false
        }
        if let port = Int(serverPort),
            port > 0
        {
            return true
        }
        return false
    }
    
    @objc fileprivate func serverPortChanged_(_ sender: UITextField)
    {
        let senderText = sender.text ?? ""
        self.actionToEnable?.isEnabled = isServerPortStringValid_(senderText)
    }
}
