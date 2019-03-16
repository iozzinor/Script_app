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
    public func prepareToDisplayRoundStyle()
    {
        layer.backgroundColor = UIColor.blue.cgColor
        layer.cornerRadius = frame.height / 2
    }
}
