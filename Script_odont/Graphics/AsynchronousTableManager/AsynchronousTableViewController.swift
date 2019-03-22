//
//  AsynchronousTableViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 20/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class AsynchronousTableViewController<Section: TableSection, Row: TableRow, ErrorView: UIView, EmptyView: UIView, LoadingView: UIView, ViewController: UIViewController>: UIViewController, UITableViewDelegate, UITableViewDataSource
    where ErrorView: ErrorDisplayer
{
    typealias Content = [(section: Section, rows: [Row])]
    
    enum State
    {
        case loaded(Content)
        case fetching(Content)
        case error(Error)
        case empty
    }
    
    var state = State.empty
    {
        didSet
        {
            updateTableFooterView_()
            tableView_.isScrollEnabled = scrollEnabled
            tableView_.reloadData()
        }
    }
    
    fileprivate var tableView_: UITableView!
    fileprivate var errorView_: ErrorView!
    fileprivate var emptyView_: EmptyView!
    fileprivate var loadingView_: LoadingView!
    fileprivate var viewController_: ViewController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    func setup(tableView: UITableView, errorView: ErrorView, emptyView: EmptyView, loadingView: LoadingView, viewController: ViewController)
    {
        self.tableView_ = tableView
        self.errorView_ = errorView
        self.emptyView_ = emptyView
        self.loadingView_ = loadingView
        self.viewController_ = viewController
        
        tableView_.dataSource = self
        tableView_.delegate = self
    }
    
    // -------------------------------------------------------------------------
    // MARK: - FOOTER
    // -------------------------------------------------------------------------
    fileprivate func updateTableFooterView_()
    {
        tableView_.tableFooterView = tableFooterView
        
        if let errorView = tableView_.tableFooterView as? ErrorView
        {
            errorView_.translatesAutoresizingMaskIntoConstraints = false
            let width = NSLayoutConstraint(item: errorView, attribute: .width, relatedBy: .equal, toItem: tableView_, attribute: .width, multiplier: 1.0, constant: 0.0)
            let height = NSLayoutConstraint(item: errorView, attribute: .height, relatedBy: .equal, toItem: tableView_, attribute: .height, multiplier: 1.0, constant: 0.0)
            tableView_.addConstraints([width, height])
        }
    }
    
    var tableFooterView: UIView?
    {
        switch state
        {
        case .loaded(_):
            return nil
        case .fetching(_):
            return loadingView_
        case let .error(error):
            errorView_.prepareFor(error: error)
            
            return errorView_
        case .empty:
            return emptyView_
        }
    }
    
    var scrollEnabled: Bool{
        switch state
        {
        case .error(_), .empty:
            return false
        case .fetching(_), .loaded(_):
            return true
        }
    }
    
    var content: Content {
        switch state
        {
        case let .loaded(result), let .fetching(result):
            return result
        case .empty, .error(_):
            return []
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DELEGATE
    // -------------------------------------------------------------------------
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DATA SOURCE
    // -------------------------------------------------------------------------
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return content[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let row = content[indexPath.section].rows[indexPath.row]
        let cell = row.cell(for: indexPath, tableView: tableView, viewController: viewController_)
        cell.accessoryType = row.accessoryType
        cell.selectionStyle = row.selectionStyle
        return cell
    }
}
