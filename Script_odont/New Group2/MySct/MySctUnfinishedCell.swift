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
        topicLabel.layer.cornerRadius = topicLabel.frame.height / 2.0
        topicLabel.layer.backgroundColor = Appearance.Color.color(for: sctUnfinished.session.exam.scts.first?.topic ?? .diagnostic).cgColor
        
        startDateLabel.text = Constants.dateString(for: sctUnfinished.startDate)
        if let firstSct = sctUnfinished.session.exam.scts.first
        {
            topicLabel.text = firstSct.topic.name
        }
        answeredQuestionsLabel.text = "\(sctUnfinished.answeredQuestions)"
        let totalQuestions = totalQuestionsCount_(sctUnfinished)
        progressView.progress = Float(sctUnfinished.answeredQuestions) / Float(totalQuestions)
        
        percentLabel.text = "\(Int(100.0 * Float(sctUnfinished.answeredQuestions) / Float(totalQuestions)))%"
        
        let minutes = Int(sctUnfinished.duration / 60.0)
        let seconds = Int(sctUnfinished.duration) % 60
        durationLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
}
