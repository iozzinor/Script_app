//
//  SctBrowsingCell.swift
//  Script_odont
//
//  Created by Régis Iozzino on 15/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SctBrowsingCell: UITableViewCell
{
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var questionsCountLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var starsContainer: UIStackView!
    {
        didSet
        {
            setupStars_()
        }
    }
    @IBOutlet weak var authorLastNameLabel: UILabel!
    @IBOutlet weak var authorFirstNameLabel: UILabel!
    
    fileprivate var stars_ = [PartialRateStar]()
    
    fileprivate func setupStars_()
    {
        for i in 0..<5
        {
            let newStar = PartialRateStar()
            newStar.tag = i
            newStar.lineWidth = 1
            stars_.append(newStar)
            starsContainer.addArrangedSubview(newStar)
            
            let widthHeightRatio = NSLayoutConstraint(item: newStar, attribute: .width, relatedBy: .equal, toItem: newStar, attribute: .height, multiplier: 1.0, constant: 0.0)
            newStar.addConstraint(widthHeightRatio)
        }
    }
    
    func setSctLaunchInformation(_ sctLaunchInformation: SctLaunchInformation)
    {
        topicLabel.prepareToDisplay(topic: sctLaunchInformation.sct.topic)
        
        questionsCountLabel.text = "\(sctLaunchInformation.sct.questions.count)"
        
        durationLabel.text = Constants.durationString(forTimeInterval: sctLaunchInformation.sct.estimatedDuration)
        
        setMeanVote_(sctLaunchInformation.statistics.meanVotes)
        
        authorLastNameLabel.text = sctLaunchInformation.statistics.authorLastName.uppercased()
        authorFirstNameLabel.text = sctLaunchInformation.statistics.authorFirstName
    }
    
    fileprivate func setMeanVote_(_ vote: Double)
    {
        let fullStars = Int(vote)
        
        for i in 0..<fullStars
        {
            stars_[i].value = 1.0
        }
        if fullStars < 5
        {
            stars_[fullStars].value = vote - floor(vote)
        }
        if fullStars < 4
        {
            for i in fullStars..<4
            {
                stars_[i + 1].value = 0.0
            }
        }
    }
}
