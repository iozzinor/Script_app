//
//  UICollectionViewCell+utils.swift
//  Script_odont
//
//  Created by Régis Iozzino on 21/05/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

extension UICollectionViewCell
{
    // -------------------------------------------------------------------------
    // MARK: - REUSE IDENTIFIER
    // -------------------------------------------------------------------------
    /// The nib file name associated to this collection view.
    public static var nibName: String {
        return String(describing: self)
    }
    
    /// The collection view reuse identifier.
    public static var reuseId: String {
        return String(describing: self) + "ReuseId"
    }
}
