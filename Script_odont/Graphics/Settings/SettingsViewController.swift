//
//  SettingsViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 17/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
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
    
    // -------------------------------------------------------------------------
    // MARK: - SETTINGS ROW
    // -------------------------------------------------------------------------
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
    
    @IBOutlet weak var tableView: UITableView!
    typealias TableManager = AsynchronousTableManager<SettingsSection, SettingsRow, UIView, UIView, UIView
        , SettingsViewController, SettingsViewController>
    
    fileprivate var tableManager_: TableManager!
    
    fileprivate var errorLabel_ = UILabel()
    fileprivate var errorView_ = UIView()
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
     
        errorView_.addSubview(errorLabel_)
        // errorView_.frame = view.frame
        errorLabel_.translatesAutoresizingMaskIntoConstraints = false
        errorLabel_.numberOfLines = 0
        errorLabel_.lineBreakMode = .byWordWrapping
        let left = NSLayoutConstraint(item: errorLabel_, attribute: .left, relatedBy: .equal, toItem: errorView_, attribute: .left, multiplier: 1.0, constant: 0.0)
        let centerX = NSLayoutConstraint(item: errorLabel_, attribute: .centerX, relatedBy: .equal, toItem: errorView_, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let centerY = NSLayoutConstraint(item: errorLabel_, attribute: .centerY, relatedBy: .equal, toItem: errorView_, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        errorView_.addConstraints([left, centerX, centerY])
        
        tableManager_ = TableManager(viewController: self, tableView: tableView, errorView: errorView_, emptyView: UIView(), loadingView: UIView())
        
        tableManager_.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Settings.NavigationItem.Title".localized
        
        switch Reachability.currentStatus {
        case .notReachable:
            tableManager_.state = .error(NSError(domain: "test", code: 1234, userInfo: nil))
        case .reachableViaWifi:
            tableManager_.state = .fetching([])
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                var testContent = [(section: SettingsSection, rows: [SettingsRow])]()
                testContent.append((section: .account, rows: [.version, .version]))
                testContent.append((section: .account, rows: [.version, .version, .version]))
                self.tableManager_.state = .loaded(testContent)
            })
        case .reachableViaWwan:
            tableManager_.state = .error(NSError(domain: "no wifi but wwan", code: 1234, userInfo: nil))
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DELEGATE
    // -------------------------------------------------------------------------
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DATA SOURCE
    // -------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return tableManager_.cell(for: indexPath)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return tableManager_.sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return tableManager_.rows(in: section)
    }
}

extension SettingsViewController: AsynchronousTableManagerDelegate
{
    typealias Section = SettingsSection
    typealias Row = SettingsRow
    typealias ErrorView = UIView
    typealias EmptyView = UIView
    typealias LoadingView = UIView
    typealias ViewController = SettingsViewController
    
    func prepareErrorView(_ errorView: UIView, error: Error)
    {
        errorView_.frame.size = CGSize(width: tableView.bounds.width, height: tableView.bounds.height / 2.0)
        errorLabel_.text = "An error occured: \(error.localizedDescription)"
        errorLabel_.sizeToFit()
        errorLabel_.setNeedsUpdateConstraints()
    }
    
    func asynchronousTableManager(heightForFooterView view: UIView) -> CGFloat
    {
        return UIScreen.main.bounds.height
    }
}
