//
//  TableRow.swift
//  Script_odont
//
//  Created by Régis Iozzino on 20/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

protocol TableRow
{
    associatedtype ViewController: UIViewController
    
    var accessoryType: UITableViewCell.AccessoryType { get }
    var selectionStyle: UITableViewCell.SelectionStyle { get }
    
    func cell(for indexPath: IndexPath, tableView: UITableView, viewController: UIViewController) -> UITableViewCell
}
