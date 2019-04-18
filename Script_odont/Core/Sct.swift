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
    
    /// The main SCT topic.
    public var topic: SctTopic {
        let topics = questions.map { $0.topic }
        
        var topicsDistribution = [SctTopic: Int]()
        for topic in topics
        {
            if !topicsDistribution.keys.contains(topic)
            {
                topicsDistribution[topic] = 0
            }
            topicsDistribution[topic] = topicsDistribution[topic]! + 1
        }
        
        var max = 0
        var maxTopic = SctTopic.diagnostic
        
        for (topic, count) in topicsDistribution
        {
            if count > max
            {
                max = count
                maxTopic = topic
            }
        }
        
        return maxTopic
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
