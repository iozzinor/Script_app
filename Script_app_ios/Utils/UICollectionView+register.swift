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
    /// Register a cell of a peculiar type.
    func registerCell<Cell: UICollectionViewCell>(_ cellClass: Cell.Type)
    {
        register(cellClass, forCellWithReuseIdentifier: Cell.reuseId)
    }
    
    /// Register a cell of a peculiar type, and its nib associated file.
    func registerNibCell<Cell: UICollectionViewCell>(_ cellClass: Cell.Type)
    {
        register(UINib(nibName: Cell.nibName, bundle: nil), forCellWithReuseIdentifier: Cell.reuseId)
    }
    
    /// Dequeue a cell of a peculiar type.
    func dequeueReusableCell<Cell: UICollectionViewCell>(for indexPath: IndexPath) -> Cell
    {
        return dequeueReusableCell(withReuseIdentifier: Cell.reuseId, for: indexPath) as! Cell
    }
}
