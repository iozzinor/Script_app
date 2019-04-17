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
    // -------------------------------------------------------------------------
    // MARK: - MODE
    // -------------------------------------------------------------------------
    public enum Mode
    {
        case training
        case evaluation
    }
    
    public var sct: Sct
    fileprivate var answers_: [[LikertScale.Degree?]]
    public var time: Double = 0.0
    public var mode = Mode.training
    
    // -------------------------------------------------------------------------
    // MARK: - INIT
    // -------------------------------------------------------------------------
    public init(sct: Sct)
    {
        self.sct = sct
        self.answers_ = []
        
        for question in sct.questions
        {
            let newAnswers = Array<LikertScale.Degree?>(repeating: nil, count: question.items.count)
            answers_.append(newAnswers)
        }
    }
    
    public subscript(questionIndex: Int, itemIndex: Int) -> LikertScale.Degree? {
        set {
            answers_[questionIndex][itemIndex] = newValue
        }
        
        get {
            return answers_[questionIndex][itemIndex]
        }
    }
    
    public func isSctValid(_ index: Int) -> Bool
    {
        let question = sct.questions[index]
        
        for itemIndex in 0..<question.items.count
        {
            if self[index, itemIndex] == nil
            {
                return false
            }
        }
        
        return true
    }
}
