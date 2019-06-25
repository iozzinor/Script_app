//
//  TctSession.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/05/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

/// Therapeutic Choice Training Session
struct TctSession
{
    var id: Int
    var sequenceIndex: Int
    var date: Date
    var participant: TctParticipant
    var answers: [[Int]]
    var comments: [String]
    
    init(sequenceIndex: Int, date: Date, participant: TctParticipant, answers: [[Int]])
    {
        self.init(sequenceIndex: sequenceIndex, date: date, participant: participant, answers: answers, comments: [])
    }
    
    init(sequenceIndex: Int, date: Date, participant: TctParticipant, answers: [[Int]], comments: [String])
    {
        self.init(id: -1, sequenceIndex: sequenceIndex, date: date, participant: participant, answers: answers, comments: comments)
    }
    
    init(id: Int, sequenceIndex: Int, date: Date, participant: TctParticipant, answers: [[Int]])
    {
        self.init(id: -1, sequenceIndex: sequenceIndex, date: date, participant: participant, answers: answers, comments: [])
    }
    
    init(id: Int, sequenceIndex: Int, date: Date, participant: TctParticipant, answers: [[Int]], comments: [String])
    {
        self.id = id
        self.sequenceIndex = sequenceIndex
        self.date = date
        self.participant = participant
        self.answers = answers
        self.comments = comments
    }
}
