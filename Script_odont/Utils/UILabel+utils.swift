//
//  UILabel+utils.swift
//  Script_odont
//
//  Created by Régis Iozzino on 15/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

extension UILabel
{
    // -------------------------------------------------------------------------
    // MARK: - SCT TYPE
    // -------------------------------------------------------------------------
    public func prepareToDisplay(type: SctType)
    {
        layer.cornerRadius = frame.height / 2.0
        layer.backgroundColor = Appearance.Color.color(for: type).cgColor
        text = type.name
    }
    
    // -------------------------------------------------------------------------
    // MARK: - BUTTON STYLE
    // -------------------------------------------------------------------------
    public func prepareToDisplayRoundStyle(enabled: Bool = true)
    {
        textAlignment = .center
        let color = (enabled ? UIColor.blue : UIColor.gray)
        layer.backgroundColor = color.cgColor
        layer.cornerRadius = frame.height / 4
    }
}
