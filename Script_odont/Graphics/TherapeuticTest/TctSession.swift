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
    var date: Date
    var participant: TctParticipant
    var answers: [[Int]]
    var comments: [String]
    
    init(date: Date, participant: TctParticipant, answers: [[Int]])
    {
        self.date = date
        self.participant = participant
        self.answers = answers
        self.comments = []
    }
    
    init(date: Date, participant: TctParticipant, answers: [[Int]], comments: [String])
    {
        self.date = date
        self.participant = participant
        self.answers = answers
        self.comments = comments
    }
}
