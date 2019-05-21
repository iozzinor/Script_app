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
    public static var nibName: String {
        return String(describing: self)
    }
    
    public static var reuseId: String {
        return String(describing: self) + "ReuseId"
    }
}
