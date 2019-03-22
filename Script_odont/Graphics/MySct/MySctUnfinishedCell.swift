//
//  MySctUnfinishedCell.swift
//  Script_odont
//
//  Created by Régis Iozzino on 09/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class MySctUnfinishedCell: UITableViewCell
{
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var answeredQuestionsLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var authorLastNameLabel: UILabel!
    @IBOutlet weak var authorFirstNameLabel: UILabel!
    
    fileprivate func totalQuestionsCount_(_ sctUnfinished: SctUnfinished) -> Int
    {
        let exam = sctUnfinished.session.exam
        var result = 0
        
        for sct in exam.scts
        {
            result += sct.questions.count
        }
        
        return result
    }
    
    func setSctUnfinished(_ sctUnfinished: SctUnfinished)
    {
        topicLabel.prepareToDisplay(topic: sctUnfinished.session.exam.topic)
        
        startDateLabel.text = Constants.dateString(for: sctUnfinished.startDate)
        answeredQuestionsLabel.text = "\(sctUnfinished.answeredQuestions)"
        let totalQuestions = totalQuestionsCount_(sctUnfinished)
        progressView.progress = Float(sctUnfinished.answeredQuestions) / Float(totalQuestions)
        
        percentLabel.text = "\(Int(100.0 * Float(sctUnfinished.answeredQuestions) / Float(totalQuestions)))%"
        
        durationLabel.text = Constants.durationString(forTimeInterval: sctUnfinished.duration)
        
        authorLastNameLabel.text = sctUnfinished.statistics.authorLastName.uppercased()
        authorFirstNameLabel.text = sctUnfinished.statistics.authorFirstName
    }
}
