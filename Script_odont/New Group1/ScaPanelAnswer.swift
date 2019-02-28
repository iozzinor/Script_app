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
    // -------------------------------------------------------------------------
    // MARK: - VALIDATION
    // -------------------------------------------------------------------------
    public enum ValidationStatus
    {
        case valid
        case invalid(ValidationError)
    }
    
    public enum ValidationError
    {
        case insufficientPeers(expected: Int, actual: Int)
        case wrongVariance(Double)
        case wholeScale
        case extremities
        case bimodal
    }
    
    public static let minimumPeerReviews = 10
    
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
            if answerIndex > answers_.count - 1
            {
                answers_.append(ScaAnswer(exam: exam))
            }
            
            answers_[answerIndex][scaIndex, questionIndex] = newValue
        }
        get {
            return answers_[answerIndex][scaIndex, questionIndex]
        }
    }
    
    /// - returns: The validity status for each question in an sca.
    public func checkValidity(scaIndex: Int) -> [ValidationStatus]
    {
        var result = [ValidationStatus]()
        
        for i in 0..<exam.scas[scaIndex].questions.count
        {
            result.append(checkValidity(scaIndex: scaIndex, questionIndex: i))
        }
        
        return result
    }
    
    /// - returns: The validity status for a given question.
    public func checkValidity(scaIndex: Int, questionIndex: Int) -> ValidationStatus
    {
        // peers count
        if answers_.count < ScaPanelAnswer.minimumPeerReviews
        {
            return .invalid(.insufficientPeers(expected: ScaPanelAnswer.minimumPeerReviews, actual: answers_.count))
        }
        
        let currentResponses = responses(forSca: scaIndex, questionIndex: questionIndex)
        // variance
        let variance = variance_(currentResponses)
        if variance < 0.5 || variance > 1.0
        {
            return .invalid(.wrongVariance(variance))
        }
        
        // whole scale
        var wholeScale = true
        for response in currentResponses
        {
            if response == 0
            {
                wholeScale = false
                break
            }
        }
        if wholeScale
        {
            return .invalid(.wholeScale)
        }
        
        // extremities
        if currentResponses.first! > 0 && currentResponses.last! > 0
        {
            return .invalid(.extremities)
        }
        
        // bimodal
        
        return .valid
    }
    
    // -------------------------------------------------------------------------
    // MARK: - POINTS
    // -------------------------------------------------------------------------
    func responses(forSca scaIndex: Int, questionIndex: Int) -> [Int]
    {
        var result = Array<Int>(repeating: 0, count: LikertScale.Degree.allCases.count)
        
        for answer in answers_
        {
            let degree = answer[scaIndex, questionIndex]
            result[degree.rawValue] += 1
        }
        
        return result
    }
    
    func points(forSca scaIndex: Int, questionIndex: Int) -> [Double]
    {
        let currentReponses = responses(forSca: scaIndex, questionIndex: questionIndex)
        return points(forResponses: currentReponses)
    }
    
    func points(forResponses responses: [Int]) -> [Double]
    {
        var maximum = responses.max() ?? 1
        if maximum == 0
        {
            maximum = 1
        }
        
        return responses.map { Double($0) / Double(maximum) }
    }
    
    func mean_(_ points: [Int]) -> Double
    {
        if points.isEmpty
        {
            return 0.0
        }
        var result = 0.0
        var pointsCount = 0
        
        for (i, point) in points.enumerated()
        {
            result += Double(i - 2) * Double(point)
            pointsCount += point
        }
        
        return result / Double(pointsCount)
    }
    
    func variance_(_ responses: [Int]) -> Double
    {
        if responses.isEmpty
        {
            return 0.0
        }
        
        let mean = mean_(responses)
        var responsesCount = -1
        for response in responses
        {
            responsesCount += response
        }
        
        var result = 0.0
        for (i, response) in responses.enumerated()
        {
            let code = Double(i - 2)
            let frequency = Double(response) / Double(responsesCount)
            result += frequency * code * code
        }
        
        return result - mean * mean
    }
}
