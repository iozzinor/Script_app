//
//  Appearance.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

/// Gather information related to the application appearance.
/// The intend is to unify the global user interface.
struct Appearance
{
    /// General colors
    struct Color
    {
        public static let `default` = UIColor.black
        public static let missing = UIColor.gray
    }
    
    /// Appearance of sca related views.
    struct Sca
    {
    }
    
    /// Appearance for likert scale.
    struct LikertScale
    {
        struct Color
        {
            public static let negativeTwo   = UIColor.red
            public static let negativeOne   = UIColor.orange
            public static let zero          = UIColor.yellow
            public static let one           = UIColor.blue
            public static let two           = UIColor.green
            
            public static let all = [ negativeTwo, negativeOne, zero, one, two ]
        }
    }
}
