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
    
    fileprivate func totalItemsCount_(_ sctUnfinished: SctUnfinished) -> Int
    {
        let sct = sctUnfinished.session.sct
        var result = 0
        
        for question in sct.questions
        {
            result += question.items.count
        }
        
        return result
    }
    
    func setSctUnfinished(_ sctUnfinished: SctUnfinished)
    {
        topicLabel.prepareToDisplay(topic: sctUnfinished.session.sct.topic)
        
        startDateLabel.text = Constants.dateString(for: sctUnfinished.startDate)
        answeredQuestionsLabel.text = "\(sctUnfinished.answeredQuestions)"
        let totalItems = totalItemsCount_(sctUnfinished)
        progressView.progress = Float(sctUnfinished.answeredQuestions) / Float(totalItems)
        
        percentLabel.text = "\(Int(100.0 * Float(sctUnfinished.answeredQuestions) / Float(totalItems)))%"
        
        durationLabel.text = Constants.durationString(forTimeInterval: sctUnfinished.duration)
        
        authorLastNameLabel.text = sctUnfinished.statistics.authorLastName.uppercased()
        authorFirstNameLabel.text = sctUnfinished.statistics.authorFirstName
    }
}
