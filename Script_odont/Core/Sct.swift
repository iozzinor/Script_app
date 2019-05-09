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
    
    /// The main SCT type.
    public var type: SctType {
        let types = questions.map { $0.type }
        
        var typesDistribution = [SctType: Int]()
        for type in types
        {
            if !typesDistribution.keys.contains(type)
            {
                typesDistribution[type] = 0
            }
            typesDistribution[type] = typesDistribution[type]! + 1
        }
        
        var max = 0
        var maxType = SctType.diagnostic
        
        for (type, count) in typesDistribution
        {
            if count > max
            {
                max = count
                maxType = type
            }
        }
        
        return maxType
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
