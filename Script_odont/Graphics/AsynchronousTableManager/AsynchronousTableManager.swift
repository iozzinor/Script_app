//
//  AsynchronousTableManager.swift
//  Script_odont
//
//  Created by Régis Iozzino on 20/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class AsynchronousTableManager<ErrorView: UIView, EmptyView: UIView, LoadingView: UIView>
{
    enum State
    {
        case loaded
        case fetching
        case error(Error)
        case empty
    }
    
    var state = State.empty
    
    fileprivate var tableView_: UITableView
    fileprivate var errorView_: ErrorView
    fileprivate var emptyView_: EmptyView
    fileprivate var loadingView_: LoadingView
    
    init(tableView: UITableView, errorView: ErrorView, emptyView: EmptyView, loadingView: LoadingView)
    {
        self.tableView_ = tableView
        self.errorView_ = errorView
        self.emptyView_ = emptyView
        self.loadingView_ = loadingView
    }
    
    func cell(for indexPath: IndexPath) -> UITableViewCell
    {
        return UITableViewCell()
    }
    
    var footerView: UIView?
    {
        switch state
        {
        case .loaded:
            return nil
        case .fetching:
            return loadingView_
        case .error(_):
            return errorView_
        case .empty:
            return emptyView_
        }
    }
}
