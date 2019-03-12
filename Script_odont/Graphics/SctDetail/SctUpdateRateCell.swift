//
//  SctUpdateRateCell.swift
//  Script_odont
//
//  Created by Régis Iozzino on 12/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SctUpdateRateCell: UITableViewCell
{
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var starsContainer: UIStackView!
    
    weak var delegate: SctUpdateRateCellDelegate? = nil
    
    fileprivate var stars_ = [RateStar]()
    fileprivate var selectedStar_ = -1
    var selectedStar: Int {
        get {
            return selectedStar_
        }
        set {
            selectedStar_ = newValue
            setupStars_()
            
            for (i, star) in stars_.enumerated()
            {
                let isSelected = (i <= newValue)
                star.setIsSelected(isSelected, animated: false)
            }
        }
    }
    
    
    fileprivate func setupStars_()
    {
        guard stars_.isEmpty else
        {
            return
        }
        for i in 0..<5
        {
            let newStar = RateStar()
            newStar.tag = i
            newStar.preventAnimation = true
            newStar.addTarget(self, action: #selector(SctUpdateRateCell.starSelected_), for: .valueChanged)
            stars_.append(newStar)
            starsContainer.addArrangedSubview(newStar)
        }
    }
    
    @objc fileprivate func starSelected_(_ sender: RateStar)
    {
        let starIndex = sender.tag
        
        for (i, star) in stars_.enumerated()
        {
            let isSelected = (i <= starIndex)
            
            let animated: Bool
            if i != starIndex
            {
                animated = true
            }
            else
            {
                animated = selectedStar_ < starIndex
                star.setIsSelected(false, animated: false)
            }
            
            star.setIsSelected(isSelected, animated: animated)
        }
        
        selectedStar_ = starIndex
        delegate?.sctUpdateRateCell(self, didChooseRate: starIndex + 1)
    }
}
