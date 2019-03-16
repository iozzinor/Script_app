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
    
    func setPeriod(_ period: String, sctsCount: Int)
    {
        periodLabel.text = period
        sctsCountLabel.text = "\(sctsCount)"
        
        if sctsCountLabel.tag < 1
        {
            sctsCountLabel.tag = 1
            
            sctsCountLabel.textAlignment = .center
            sctsCountLabel.textColor = UIColor.white
        }
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = CGRect(origin: CGPoint.zero, size: sctsCountLabel.frame.size)
        maskLayer.path = UIBezierPath(ovalIn: maskLayer.frame).cgPath
        maskLayer.fillColor = UIColor.black.cgColor
        
        sctsCountLabel.layer.mask = maskLayer
        sctsCountLabel.layer.backgroundColor = UIColor.red.withAlphaComponent(0.9).cgColor
    }
}
