//
//  SecurityQuestion.swift
//  Script_odont
//
//  Created by Régis Iozzino on 02/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

struct SecurityQuestion
{
    enum Heading: Int, CaseIterable
    {
        case childhoodCity
        case parentMeetingCity
        case childhoodStreet
        case firstPet
        case favoriteBand
        case favoriteSong
        case favoriteMovie
        case dreamJob
        
        var content: String {
            switch self
            {
            case .childhoodCity:
                return "SecurityQuestion.Content.ChildhoodCity".localized
            case .parentMeetingCity:
                return "SecurityQuestion.Content.ParentMeetingCity".localized
            case .childhoodStreet:
                return "SecurityQuestion.Content.ChildhoodStreet".localized
            case .firstPet:
                return "SecurityQuestion.Content.FirstPet".localized
            case .favoriteBand:
                return "SecurityQuestion.Content.FavoriteBand".localized
            case .favoriteSong:
                return "SecurityQuestion.Content.FavoriteSong".localized
            case .favoriteMovie:
                return "SecurityQuestion.Content.FavoriteMovie".localized
            case .dreamJob:
                return "SecurityQuestion.Content.DreamJob".localized
            }
        }
    }
    
    var heading: Heading
    var answer: String
}
