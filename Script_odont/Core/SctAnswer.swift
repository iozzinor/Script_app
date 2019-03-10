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
    fileprivate var answers_: [[LikertSctle.Degree]]
    
    public init(exam: SctExam)
    {
        self.answers_ = []
        
        for sct in exam.scts
        {
            let newAnswers = Array<LikertSctle.Degree>(repeating: .zero, count: sct.questions.count)
            answers_.append(newAnswers)
        }
    }
    
    public subscript(sctIndex: Int, questionIndex: Int) -> LikertSctle.Degree {
        set {
            answers_[sctIndex][questionIndex] = newValue
        }
        
        get {
            return answers_[sctIndex][questionIndex]
        }
    }
}
