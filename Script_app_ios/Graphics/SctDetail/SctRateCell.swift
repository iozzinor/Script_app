//
//  SctRateCell.swift
//  Script_odont
//
//  Created by Régis Iozzino on 12/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SctRateCell: UITableViewCell
{
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var starsContainer: UIStackView!
    
    fileprivate var stars_ = [PartialRateStar]()
    
    var rate: Double = 2.5 {
        didSet {
            if !Constants.inRange(rate, min: 0.0, max: 5.0)
            {
                rate = Constants.bound(rate, min: 0.0, max: 5.0)
            }
            
            if stars_.isEmpty
            {
                appendStars_()
            }
            
            // full
            let fullStars = Int(floor(rate))
            for i in 0..<fullStars
            {
                stars_[i].value = 1.0
            }
            
            // partial
            if fullStars < 5
            {
                let lastStarValue = rate - floor(rate)
                stars_[fullStars].value = lastStarValue
            }
            
            // empty
            if fullStars < 4
            {
                for i in (fullStars + 1)..<5
                {
                    stars_[i].value = 0.0
                }
            }
        }
    }
    
    
    fileprivate func appendStars_()
    {
        for _ in 0..<5
        {
            let newStar = PartialRateStar()
            stars_.append(newStar)
            starsContainer.addArrangedSubview(newStar)
        }
    }
}
