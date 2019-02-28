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
    case patientCare
    
    public var name: String {
        switch self
        {
        case .diagnostic:
            return "Diagnostic"
        case .therapeutic:
            return "Therapeutic"
        case .patientCare:
            return "Patient Care"
        }
    }
    
    public var likertScale: LikertScale {
        switch self
        {
        case .diagnostic:
            return LikertScale(
                negativeTwo: "L'hypothèse est pratiquement éliminée",
                negativeOne: "L'hypothèse devient moins probable",
                zero: "L'information n'a aucun effet sur l'hypothèse",
                one: "L'hypothèse devient plus probable",
                two: "Il ne peut s'agir pratiquement que de cette hypothèse")
        case .therapeutic:
            return LikertScale(
                negativeTwo: "Absolument contre-indiqué",
                negativeOne: "Moins indiqué",
                zero: "Ni contre-indiqué ni indiqué",
                one: "Indiqué",
                two: "Indispensable")
        case .patientCare:
            return LikertScale(
                negativeTwo: "Absolument inutile",
                negativeOne: "Peu utile",
                zero: "Ni utile ni inutile",
                one: "Utile",
                two: "Très utile")
        }
    }
}
