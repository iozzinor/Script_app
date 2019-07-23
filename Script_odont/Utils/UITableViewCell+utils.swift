//
//  UITableViewCell+id.swift
//  Script_odont
//
//  Created by Régis Iozzino on 21/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

extension UITableViewCell: Reusable
{
    // -------------------------------------------------------------------------
    // MARK: - REUSE IDENTIFIER
    // -------------------------------------------------------------------------
    /// The name of the Nib file associated to the table.
    public static var nibName: String {
        return String(describing: self)
    }
    
    /// The table reuse identifier.
    public static var reuseId: String {
        return String(describing: self) + "ReuseId"
    }
}
