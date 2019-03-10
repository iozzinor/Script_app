//
//  SctSession.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

public class SctSession
{
    public var exam: SctExam
    fileprivate var answers_: [[LikertSctle.Degree?]]
    public var time: Double = 0.0
    
    public init(exam: SctExam)
    {
        self.exam = exam
        self.answers_ = []
        
        for sct in exam.scts
        {
            let newAnswers = Array<LikertSctle.Degree?>(repeating: nil, count: sct.questions.count)
            answers_.append(newAnswers)
        }
    }
    
    public subscript(sctIndex: Int, questionIndex: Int) -> LikertSctle.Degree? {
        set {
            answers_[sctIndex][questionIndex] = newValue
        }
        
        get {
            return answers_[sctIndex][questionIndex]
        }
    }
    
    public func isSctValid(_ index: Int) -> Bool
    {
        let sct = exam.scts[index]
        
        for questionIndex in 0..<sct.questions.count
        {
            if self[index, questionIndex] == nil
            {
                return false
            }
        }
        
        return true
    }
}
