//
//  ScaSession.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

public class ScaSession
{
    public var exam: ScaExam
    fileprivate var answers_: [[LikertScale.Degree?]]
    public var time: Double = 0.0
    
    public init(exam: ScaExam)
    {
        self.exam = exam
        self.answers_ = []
        
        for sca in exam.scas
        {
            let newAnswers = Array<LikertScale.Degree?>(repeating: nil, count: sca.questions.count)
            answers_.append(newAnswers)
        }
    }
    
    public subscript(scaIndex: Int, questionIndex: Int) -> LikertScale.Degree? {
        set {
            answers_[scaIndex][questionIndex] = newValue
        }
        
        get {
            return answers_[scaIndex][questionIndex]
        }
    }
}
