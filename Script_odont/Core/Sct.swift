//
//  SctExam.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

/// A set of SCTs.
public struct Sct
{
    /// The maximum number of items in an SCT.
    public static let maximumTotalItemsCount = 65536
    
    /// The SCT questions.
    public var questions = [SctQuestion]()
    
    /// The SCT topic.
    public var topic: SctTopic {
        return questions.first?.topic ?? .diagnostic
    }
    
    /// The number of items in the SCT.
    public var totalItemsCount: Int {
        var result = 0
        for question in questions
        {
            result += question.items.count
        }
        return result
    }
    
    /// The estimated duration in seconds, based on the number of questions.
    public var estimatedDuration: TimeInterval {
        return Double(totalItemsCount) * 20.0
    }
}
