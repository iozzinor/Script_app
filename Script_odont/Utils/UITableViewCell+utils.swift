//
//  UITableViewCell+id.swift
//  Script_odont
//
//  Created by Régis Iozzino on 21/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

extension UITableViewCell
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
