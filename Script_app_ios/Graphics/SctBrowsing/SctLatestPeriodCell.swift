//
//  SctLatestPeriodCell.swift
//  Script_odont
//
//  Created by Régis Iozzino on 15/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SctLatestPeriodCell: UITableViewCell
{
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var sctsCountLabel: UILabel!
    
    let notificationColor = UIColor.blue.withAlphaComponent(0.8)
    
    fileprivate var circleLayer_: CALayer? = nil
    
    func setPeriod(_ period: String, sctsCount: Int)
    {
        periodLabel.text = period
        sctsCountLabel.text = "\(sctsCount)"
        
        if circleLayer_ == nil
        {
            setupCircleLayer_()
            sctsCountLabel.textAlignment = .center
            sctsCountLabel.textColor = notificationColor
        }
        
        let size = min(sctsCountLabel.frame.size.width, sctsCountLabel.frame.size.height)
        let newSize = CGSize(width: size, height: size)
        sctsCountLabel.layer.frame.size = newSize
        circleLayer_?.frame.size = newSize
        circleLayer_?.cornerRadius = size / 2.0
    }
    
    fileprivate func setupCircleLayer_()
    {
        circleLayer_ = CALayer()
        circleLayer_?.borderColor = notificationColor.cgColor
        circleLayer_?.borderWidth = 2.0
        circleLayer_?.backgroundColor = nil
        
        sctsCountLabel.layer.addSublayer(circleLayer_!)
    }
}
