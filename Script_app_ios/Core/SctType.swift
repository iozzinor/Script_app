//
//  LikertSctle.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

/// The SCT type.
public enum SctType: Int, CaseIterable
{
    case diagnostic
    case therapeutic
    case prognostic
    
    public var name: String {
        switch self
        {
        case .diagnostic:
            return "Sct.Type.Diagnostic".localized
        case .therapeutic:
            return "Sct.Type.Therapeutic".localized
        case .prognostic:
            return "Sct.Type.Prognostic".localized
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
                negativeTwo:    "Sct.Type.Diagnostic.NegativeTwo".localized,
                negativeOne:    "Sct.Type.Diagnostic.NegativeOne".localized,
                zero:           "Sct.Type.Diagnostic.Zero".localized,
                one:            "Sct.Type.Diagnostic.One".localized,
                two:            "Sct.Type.Diagnostic.Two".localized)
        case .therapeutic:
            return LikertScale(
                negativeTwo:    "Sct.Type.Therapeutic.NegativeTwo".localized,
                negativeOne:    "Sct.Type.Therapeutic.NegativeOne".localized,
                zero:           "Sct.Type.Therapeutic.Zero".localized,
                one:            "Sct.Type.Therapeutic.One".localized,
                two:            "Sct.Type.Therapeutic.Two".localized)
        case .prognostic:
            return LikertScale(
                negativeTwo:    "Sct.Type.Prognostic.NegativeTwo".localized,
                negativeOne:    "Sct.Type.Prognostic.NegativeOne".localized,
                zero:           "Sct.Type.Prognostic.Zero".localized,
                one:            "Sct.Type.Prognostic.One".localized,
                two:            "Sct.Type.Prognostic.Two".localized)
        }
    }
}
