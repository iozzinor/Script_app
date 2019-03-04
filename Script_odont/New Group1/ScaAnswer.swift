//
//  ScaAnswer.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

/// Answers to an SCA.
public struct ScaAnswer
{
    fileprivate var answers_: [[LikertScale.Degree]]
    
    public init(exam: ScaExam)
    {
        self.answers_ = []
        
        for sca in exam.scas
        {
            let newAnswers = Array<LikertScale.Degree>(repeating: .zero, count: sca.questions.count)
            answers_.append(newAnswers)
        }
    }
    
    public subscript(scaIndex: Int, questionIndex: Int) -> LikertScale.Degree {
        set {
            answers_[scaIndex][questionIndex] = newValue
        }
        
        get {
            return answers_[scaIndex][questionIndex]
        }
    }
}
