//
//  LikertScale.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

public enum ScaTopic: Int, CaseIterable
{
    case diagnostic
    case therapeutic
    case prognostic
    
    public var name: String {
        switch self
        {
        case .diagnostic:
            return "Sca.Topic.Diagnostic".localized
        case .therapeutic:
            return "Sca.Topic.Therapeutic".localized
        case .prognostic:
            return "Sca.Topic.Prognostic".localized
        }
    }
    
    public var next: ScaTopic {
        if rawValue > ScaTopic.allCases.count - 2
        {
            return ScaTopic(rawValue: 0)!
        }
        return ScaTopic(rawValue: rawValue + 1)!
    }
    
    public var likertScale: LikertScale {
        switch self
        {
        case .diagnostic:
            return LikertScale(
                negativeTwo:    "Sca.Topic.Diagnostic.NegativeTwo".localized,
                negativeOne:    "Sca.Topic.Diagnostic.NegativeOne".localized,
                zero:           "Sca.Topic.Diagnostic.Zero".localized,
                one:            "Sca.Topic.Diagnostic.One".localized,
                two:            "Sca.Topic.Diagnostic.Two".localized)
        case .therapeutic:
            return LikertScale(
                negativeTwo:    "Sca.Topic.Therapeutic.NegativeTwo".localized,
                negativeOne:    "Sca.Topic.Therapeutic.NegativeOne".localized,
                zero:           "Sca.Topic.Therapeutic.Zero".localized,
                one:            "Sca.Topic.Therapeutic.One".localized,
                two:            "Sca.Topic.Therapeutic.Two".localized)
        case .prognostic:
            return LikertScale(
                negativeTwo:    "Sca.Topic.Prognostic.NegativeTwo".localized,
                negativeOne:    "Sca.Topic.Prognostic.NegativeOne".localized,
                zero:           "Sca.Topic.Prognostic.Zero".localized,
                one:            "Sca.Topic.Prognostic.One".localized,
                two:            "Sca.Topic.Prognostic.Two".localized)
        }
    }
}
