//
//  SctPanelAnswer.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

public struct SctPanelAnswer
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
    
    public var exam: SctExam
    fileprivate var answers_: [SctAnswer]
    
    public init(exam: SctExam)
    {
        self.exam = exam
        self.answers_ = []
    }

    public subscript(answerIndex: Int, sctIndex: Int, questionIndex: Int) -> LikertScale.Degree
    {
        set {
            if answerIndex > answers_.count - 1
            {
                answers_.append(SctAnswer(exam: exam))
            }
            
            answers_[answerIndex][sctIndex, questionIndex] = newValue
        }
        get {
            return answers_[answerIndex][sctIndex, questionIndex]
        }
    }
    
    /// - returns: The validity status for each question in an sct.
    public func checkValidity(sctIndex: Int) -> [ValidationStatus]
    {
        var result = [ValidationStatus]()
        
        for i in 0..<exam.scts[sctIndex].questions.count
        {
            result.append(checkValidity(sctIndex: sctIndex, questionIndex: i))
        }
        
        return result
    }
    
    /// - returns: The validity status for a given question.
    public func checkValidity(sctIndex: Int, questionIndex: Int) -> ValidationStatus
    {
        // peers count
        if answers_.count < SctPanelAnswer.minimumPeerReviews
        {
            return .invalid(.insufficientPeers(expected: SctPanelAnswer.minimumPeerReviews, actual: answers_.count))
        }
        
        let currentResponses = responses(forSct: sctIndex, questionIndex: questionIndex)
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
        for i in 1..<(currentResponses.count-1)
        {
            if currentResponses[i] != 0
            {
                continue
            }
            
            var dataBefore = false
            var dataAfter = false
            for j in 0..<i
            {
                if currentResponses[j] > 0
                {
                    dataBefore = true
                    break
                }
            }
            for j in (i+1)..<currentResponses.count
            {
                if currentResponses[j] > 0
                {
                    dataAfter = true
                    break
                }
            }
            
            if dataBefore && dataAfter
            {
                return .invalid(.bimodal)
            }
        }
        
        return .valid
    }
    
    // -------------------------------------------------------------------------
    // MARK: - POINTS
    // -------------------------------------------------------------------------
    func responses(forSct sctIndex: Int, questionIndex: Int) -> [Int]
    {
        var result = Array<Int>(repeating: 0, count: LikertScale.Degree.allCases.count)
        
        for answer in answers_
        {
            let degree = answer[sctIndex, questionIndex]
            result[degree.rawValue] += 1
        }
        
        return result
    }
    
    func points(forSct sctIndex: Int, questionIndex: Int) -> [Double]
    {
        let currentReponses = responses(forSct: sctIndex, questionIndex: questionIndex)
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
