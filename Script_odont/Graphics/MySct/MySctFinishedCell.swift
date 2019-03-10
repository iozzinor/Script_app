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
    
    func setSctFinished(_ sctFinished: SctFinished)
    {
        let startDateString = Constants.dateString(for: sctFinished.startDate)
        startDateLabel.text = startDateString
        
        topicLabel.text = sctFinished.session.exam.scts.first?.topic.name
        topicLabel.layer.cornerRadius = topicLabel.frame.height / 2.0
        topicLabel.layer.backgroundColor = Appearance.Color.color(for: sctFinished.session.exam.scts.first?.topic ?? .diagnostic).cgColor
        
        scoreLabel.text = "\(sctFinished.score)%"
        
        answeredQuestionsLabel.text = "\(sctFinished.answeredQuestions)"
        
        let minutes = Int(sctFinished.duration / 60.0)
        let seconds = Int(sctFinished.duration) % 60
        durationLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
}
