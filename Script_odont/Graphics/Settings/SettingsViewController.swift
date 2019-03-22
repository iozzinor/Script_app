//
//  SettingsViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 17/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

// -------------------------------------------------------------------------
// MARK: - SETTINGS SECTION
// -------------------------------------------------------------------------
enum SettingsSection: TableSection
{
    case account
    case application
    case other
    
    var headerTitle: String? {
        return ""
    }
}

// -----------------------------------------------------------------------------
// MARK: - SETTINGS ROW
// -----------------------------------------------------------------------------
enum SettingsRow: TableRow
{
    typealias ViewController = SettingsViewController
    
    case confidentialData
    case password
    case qualifications
    
    case version
    
    case logout
    
    func cell(for indexPath: IndexPath, tableView: UITableView, viewController: UIViewController) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "this is a test"
        return cell
    }
    
    var accessoryType: UITableViewCell.AccessoryType {
        return .none
    }
    
    var selectionStyle: UITableViewCell.SelectionStyle {
        return .none
    }
}

// -----------------------------------------------------------------------------
// MARK: - SETTINGS VIEW CONTROLLER
// -----------------------------------------------------------------------------
class SettingsViewController: AsynchronousTableViewController<SettingsSection, SettingsRow, ErrorButtonView, UIView, UIView, UIViewController>
{
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var errorView_ = ErrorButtonView()
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setup(tableView: tableView, errorView: errorView_, emptyView: UIView(), loadingView: UIView(), viewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Settings.NavigationItem.Title".localized
        
        switch Reachability.currentStatus {
        case .notReachable:
            state = .error(NSError(domain: "test", code: 1234, userInfo: nil))
        case .reachableViaWifi:
            state = .error(NSError(domain: "temp", code: 1234, userInfo: nil))
            //state = .fetching([])
            /*DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                var testContent = [(section: SettingsSection, rows: [SettingsRow])]()
                testContent.append((section: .account, rows: [.version, .version]))
                testContent.append((section: .account, rows: [.version, .version, .version]))
                self.state = .loaded(testContent)
            })*/
        case .reachableViaWwan:
          state = .error(NSError(domain: "no wifi but wwan", code: 1234, userInfo: nil))
        }
    }
}
