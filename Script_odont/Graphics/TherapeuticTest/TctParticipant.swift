//
//  Participant.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/05/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

struct TctParticipant
{
    let firstName: String
    let category: ParticipantCategory
    
    /// The exercise duration in years.
    let exerciseDuration: Int?
    
    init(firstName: String, category: ParticipantCategory)
    {
        self.init(firstName: firstName, category: category, exerciseDuration: nil)
    }
    
    init(firstName: String, category: ParticipantCategory, exerciseDuration: Int?)
    {
        self.firstName = firstName
        self.category = category
        self.exerciseDuration = exerciseDuration
    }
}
