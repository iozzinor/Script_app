//
//  LikertSctle.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

/// The SCT topic.
public enum SctType: Int, CaseIterable
{
    case diagnostic
    case therapeutic
    case prognostic
    
    public var name: String {
        switch self
        {
        case .diagnostic:
            return "Sct.Topic.Diagnostic".localized
        case .therapeutic:
            return "Sct.Topic.Therapeutic".localized
        case .prognostic:
            return "Sct.Topic.Prognostic".localized
        }
    }
    
    public var next: SctType {
        if rawValue > SctType.allCases.count - 2
        {
            return SctType(rawValue: 0)!
        }
        return SctType(rawValue: rawValue + 1)!
    }
    
    public var likertScale: LikertScale {
        switch self
        {
        case .diagnostic:
            return LikertScale(
                negativeTwo:    "Sct.Topic.Diagnostic.NegativeTwo".localized,
                negativeOne:    "Sct.Topic.Diagnostic.NegativeOne".localized,
                zero:           "Sct.Topic.Diagnostic.Zero".localized,
                one:            "Sct.Topic.Diagnostic.One".localized,
                two:            "Sct.Topic.Diagnostic.Two".localized)
        case .therapeutic:
            return LikertScale(
                negativeTwo:    "Sct.Topic.Therapeutic.NegativeTwo".localized,
                negativeOne:    "Sct.Topic.Therapeutic.NegativeOne".localized,
                zero:           "Sct.Topic.Therapeutic.Zero".localized,
                one:            "Sct.Topic.Therapeutic.One".localized,
                two:            "Sct.Topic.Therapeutic.Two".localized)
        case .prognostic:
            return LikertScale(
                negativeTwo:    "Sct.Topic.Prognostic.NegativeTwo".localized,
                negativeOne:    "Sct.Topic.Prognostic.NegativeOne".localized,
                zero:           "Sct.Topic.Prognostic.Zero".localized,
                one:            "Sct.Topic.Prognostic.One".localized,
                two:            "Sct.Topic.Prognostic.Two".localized)
        }
    }
}
