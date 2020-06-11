//
//  SctAnswer.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

/// Answers to an SCT.
public struct SctAnswer
{
    fileprivate var answers_: [[LikertScale.Degree]]
    
    public init(sct: Sct)
    {
        self.answers_ = []
        
        for question in sct.questions
        {
            let newAnswers = Array<LikertScale.Degree>(repeating: .zero, count: question.items.count)
            answers_.append(newAnswers)
        }
    }
    
    public subscript(questionIndex: Int, itemIndex: Int) -> LikertScale.Degree {
        set {
            answers_[questionIndex][itemIndex] = newValue
        }
        
        get {
            return answers_[questionIndex][itemIndex]
        }
    }
}
