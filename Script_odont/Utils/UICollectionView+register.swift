//
//  UICollectionView+register.swift
//  Script_odont
//
//  Created by Régis Iozzino on 21/05/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

extension UICollectionView
{
    func registerCell<Cell: UICollectionViewCell>(_ cellClass: Cell.Type)
    {
        register(cellClass, forCellWithReuseIdentifier: Cell.reuseId)
    }
    
    func registerNibCell<Cell: UICollectionViewCell>(_ cellClass: Cell.Type)
    {
        register(UINib(nibName: Cell.nibName, bundle: nil), forCellWithReuseIdentifier: Cell.reuseId)
    }
    
    func dequeueReusableCell<Cell: UICollectionViewCell>(for indexPath: IndexPath) -> Cell
    {
        return dequeueReusableCell(withReuseIdentifier: Cell.reuseId, for: indexPath) as! Cell
    }
}
