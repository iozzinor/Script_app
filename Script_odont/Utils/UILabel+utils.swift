//
//  UILabel+sctTopic.swift
//  Script_odont
//
//  Created by Régis Iozzino on 15/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

extension UILabel
{
    // -------------------------------------------------------------------------
    // MARK: - SCT TOPIC
    // -------------------------------------------------------------------------
    public func prepareToDisplay(topic: SctTopic)
    {
        layer.cornerRadius = frame.height / 2.0
        layer.backgroundColor = Appearance.Color.color(for: topic).cgColor
        text = topic.name
    }
    
    // -------------------------------------------------------------------------
    // MARK: - BUTTON STYLE
    // -------------------------------------------------------------------------
    public func prepareToDisplayRoundStyle(enabled: Bool = true)
    {
        let color = (enabled ? UIColor.blue : UIColor.gray)
        layer.backgroundColor = color.cgColor
        layer.cornerRadius = frame.height / 2
    }
}
