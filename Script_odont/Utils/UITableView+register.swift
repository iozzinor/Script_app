//
//  UITableView+registe.swift
//  Script_odont
//
//  Created by Régis Iozzino on 21/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

extension UITableView
{
    func registerCell<Cell: UITableViewCell>(_ cellClass: Cell.Type)
    {
        register(cellClass, forCellReuseIdentifier: Cell.reuseId)
    }
    
    func registerNibCell<Cell: UITableViewCell>(_ cellClass: Cell.Type)
    {
        register(UINib(nibName: Cell.nibName, bundle: nil), forCellReuseIdentifier: Cell.reuseId)
    }
    
    func dequeueReusableCell<Cell: UITableViewCell>() -> Cell?
    {
        return dequeueReusableCell(withIdentifier: Cell.reuseId) as? Cell
    }
    
    func dequeueReusableCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell
    {
        return dequeueReusableCell(withIdentifier: Cell.reuseId, for: indexPath) as! Cell
    }
}
