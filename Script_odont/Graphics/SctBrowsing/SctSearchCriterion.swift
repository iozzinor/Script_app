//
//  SctSearchCriterion.swift
//  Script_odont
//
//  Created by Régis Iozzino on 16/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

// -------------------------------------------------------------------------
// MARK: - CRITERIA
// -------------------------------------------------------------------------
enum SctSearchCriterion
{
    static let all: [SctSearchCriterion] = [
        .topics([]), .releaseDate(Date(), Date()),
        .questionsCount(0, 0), .duration(0.0, 0.0)
    ]
    
    case topics([QualificationTopic])
    case releaseDate(Date, Date)
    case questionsCount(Int, Int)
    case duration(TimeInterval, TimeInterval)
    
    var name: String
    {
        switch self
        {
        case .topics(_):
            return "SctSearch.Criterion.Topics.Name".localized
        case .releaseDate(_, _):
            return "SctSearch.Criterion.ReleaseDate.Name".localized
        case .questionsCount(_, _):
            return "SctSearch.Criterion.QuestionsCount.Name".localized
        case .duration(_, _):
            return "SctSearch.Criterion.Duration.Name".localized
        }
    }
    
    func isIncluded(sct: Sct) -> Bool
    {
        return false
    }
    
    var multipleAppearancesAllowed: Bool {
        return false
        
    }
}
