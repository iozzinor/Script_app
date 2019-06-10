//
//  TctExporter.swift
//  Script_odont
//
//  Created by Régis Iozzino on 08/06/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

class TctExporter
{
    fileprivate static let alphabet_        = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    fileprivate static let defaultValue_    = 0
    
    /// Indexes start from 1.
    ///
    /// - returns: The column name for the given index.
    static func columnName(index: Int) -> String
    {
        if index < 0
        {
            return ""
        }
        else if index == 0
        {
            return "A"
        }
        
        // get the number of letters
        var lettersCount = 1
        var workIndex = index
        var indexLimit = TctExporter.alphabet_.count
        
        while index > indexLimit - 1
        {
            lettersCount    += 1
            indexLimit      += Constants.pow(TctExporter.alphabet_.count, lettersCount)
            workIndex       -= Constants.pow(TctExporter.alphabet_.count, lettersCount - 1)
        }
        
        var result = ""
        for i in 0..<lettersCount
        {
            let currentDivider = Constants.pow(TctExporter.alphabet_.count, lettersCount - i - 1)
            
            let currentLetterIndex = workIndex / currentDivider
            workIndex %= currentDivider
            
            let newLetterIndex = TctExporter.alphabet_.index(TctExporter.alphabet_.startIndex, offsetBy: currentLetterIndex)
            result += "\(TctExporter.alphabet_[newLetterIndex])"
        }
        return result
    }
    
    typealias Export = ([ParticipantCategory: [TctSession]], [TctSession]) -> String
    
    fileprivate var exporter_: Export
    
    init(exporter: @escaping Export)
    {
        self.exporter_ = exporter
    }
    
    func export(sequenceIndex: Int) -> String
    {
        // group by category
        let allSessions = TctSaver.getSessions(forSequenceIndex: sequenceIndex)
        
        var categorySessions = [ParticipantCategory: [TctSession]]()
        for session in allSessions
        {
            if !categorySessions.keys.contains(session.participant.category)
            {
                categorySessions[session.participant.category] = []
            }
            
            categorySessions[session.participant.category]!.append(session)
        }
        
        return exporter_(categorySessions, allSessions)
    }
}
