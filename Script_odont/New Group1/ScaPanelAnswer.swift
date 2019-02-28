//
//  ScaPanelAnswer.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

public struct ScaPanelAnswer
{
    public var exam: ScaExam
    fileprivate var answers_: [ScaAnswer]
    
    public init(exam: ScaExam)
    {
        self.exam = exam
        self.answers_ = []
    }

    public subscript(answerIndex: Int, scaIndex: Int, questionIndex: Int) -> LikertScale.Degree
    {
        set {
            if answerIndex > answers_.count
            {
                answers_.append(ScaAnswer(exam: exam))
            }
            
            answers_[answerIndex][scaIndex, questionIndex] = newValue
        }
        get {
            return answers_[answerIndex][scaIndex, questionIndex]
        }
    }
}
