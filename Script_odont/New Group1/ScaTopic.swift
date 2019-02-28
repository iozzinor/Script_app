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
    
    public var name: String {
        switch self
        {
        case .diagnostic:
            return "Diagnostic"
        case .therapeutic:
            return "Therapeutic"
        }
    }
    
    public var likertScale: LikertScale {
        switch self
        {
        case .diagnostic:
            return LikertScale(negativeTwo: "L'hypothèse est pratiquement éliminée", negativeOne: "L'hypothèse devient moins probable", zero: "L'information n'a aucun effet sur l'hypothèse", one: "L'hypothèse devient plus probable", two: "Il ne peut s'agir pratiquement que de cette hypothèse")
        case .therapeutic:
            return LikertScale(negativeTwo: "-2", negativeOne: "-1", zero: "0", one: "1", two: "2")
        }
    }
}
