//
//  AsynchronousTableManager.swift
//  Script_odont
//
//  Created by Régis Iozzino on 20/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class AsynchronousTableManager<Section: TableSection, Row: TableRow, ErrorView: UIView, EmptyView: UIView, LoadingView: UIView, ViewController: UIViewController, Delegate: AsynchronousTableManagerDelegate>
    where Delegate.ErrorView == ErrorView
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
            updateFooterView_()
            tableView_.isScrollEnabled = scrollEnabled
            tableView_.reloadData()
        }
    }
    
    weak var delegate: Delegate? = nil
    
    fileprivate var viewController_: ViewController
    fileprivate var tableView_: UITableView
    fileprivate var errorView_: ErrorView
    fileprivate var emptyView_: EmptyView
    fileprivate var loadingView_: LoadingView
    
    init(viewController: ViewController, tableView: UITableView, errorView: ErrorView, emptyView: EmptyView, loadingView: LoadingView)
    {
        self.viewController_ = viewController
        self.tableView_ = tableView
        self.errorView_ = errorView
        self.emptyView_ = emptyView
        self.loadingView_ = loadingView
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SECTIONS
    // -------------------------------------------------------------------------
    var content: Content
    {
        switch state
        {
        case .empty, .error(_):
            return []
        case let .loaded(content), let .fetching(content):
            return content
        }
    }
    
    var sectionsCount: Int {
        return content.count
    }
    
    func rows(in section: Int) -> Int
    {
        return content[section].rows.count
    }
    
    // -------------------------------------------------------------------------
    // MARK: - CELL
    // -------------------------------------------------------------------------
    func cell(for indexPath: IndexPath) -> UITableViewCell
    {
        switch state
        {
        case .error(_), .empty:
            return UITableViewCell()
            
        case let .loaded(content), let .fetching(content):
            let row = content[indexPath.section].rows[indexPath.row]
            
            let cell = row.cell(for: indexPath, tableView: tableView_, viewController: viewController_)
            cell.accessoryType = row.accessoryType
            cell.selectionStyle = row.selectionStyle
            return cell
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - FOOTER
    // -------------------------------------------------------------------------
    fileprivate func updateFooterView_()
    {
        tableView_.tableFooterView = footerView
    }
    
    var footerView: UIView?
    {
        switch state
        {
        case .loaded(_):
            return nil
        case .fetching(_):
            return loadingView_
        case let .error(error):
            delegate?.prepareErrorView(errorView_, error: error)
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
}
