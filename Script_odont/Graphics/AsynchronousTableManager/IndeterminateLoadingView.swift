//
//  IndeterminateLoadingView.swift
//  Script_odont
//
//  Created by Régis Iozzino on 27/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class IndeterminateLoadingView: UIActivityIndicatorView, TableViewFooter
{
    func prepareToDisplay(in tableView: UITableView)
    {
        //tableView_.tableFooterView?.frame.size.height = 100.0
        self.frame.size.height = self.frame.size.width
        self.startAnimating()
        self.color = UIColor.gray
    }
}
