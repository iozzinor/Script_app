//
//  LikertSctle.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

public struct LikertScale
{
    public enum Degree: Int, CaseIterable
    {
        case negativeTwo
        case negativeOne
        case zero
        case one
        case two
    }
    
    private var labels_: [String]
    
    public init(negativeTwo: String, negativeOne: String, zero: String, one: String, two: String)
    {
        labels_ = []
        labels_.append(contentsOf: [negativeTwo, negativeOne, zero, one, two])
    }
    
    public subscript(degree: Degree) -> String
    {
        return labels_[degree.rawValue]
    }
    
    public subscript(code: Int) -> String
    {
        if code + 2 < 0 || code + 1 > labels_.count
        {
            return ""
        }
        return labels_[code + 2]
    }
}
