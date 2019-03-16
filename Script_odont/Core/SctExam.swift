//
//  SctExam.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

/// A set of SCTs.
public struct SctExam
{
    public static let maximumTotalQuestionsCount = 65536
    
    public var scts = [Sct]()
    
    public var topic: SctTopic {
        return scts.first?.topic ?? .diagnostic
    }
    
    public var totalQuestionsCount: Int {
        var result = 0
        for sct in scts
        {
            result += sct.questions.count
        }
        return result
    }
    
    /// The estimated duration in seconds, based on the number of questions.
    public var estimatedDuration: TimeInterval {
        return Double(totalQuestionsCount) * 20.0
    }
}
