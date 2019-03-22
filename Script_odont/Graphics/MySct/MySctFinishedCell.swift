//
//  MySctFinishedCell.swift
//  Script_odont
//
//  Created by Régis Iozzino on 09/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class MySctFinishedCell: UITableViewCell
{
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var answeredQuestionsLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var authorLastNameLabel: UILabel!
    @IBOutlet weak var authorFirstNameLabel: UILabel!
    
    func setSctFinished(_ sctFinished: SctFinished)
    {
        let startDateString = Constants.dateString(for: sctFinished.startDate)
        startDateLabel.text = startDateString
        
        topicLabel.prepareToDisplay(topic: sctFinished.session.exam.topic)
        
        scoreLabel.text = "\(sctFinished.score)%"
        
        answeredQuestionsLabel.text = "\(sctFinished.answeredQuestions)"
        
        durationLabel.text = Constants.durationString(forTimeInterval: sctFinished.duration)
        
        authorLastNameLabel.text = sctFinished.statistics.authorLastName.uppercased()
        authorFirstNameLabel.text = sctFinished.statistics.authorFirstName
    }
}
