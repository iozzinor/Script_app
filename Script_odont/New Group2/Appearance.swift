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
        /// The default color to use for the text.
        public static let `default` = UIColor.black
        
        /// The missing color.
        public static let missing = UIColor.gray
        
        /// The color used to indicate an action might be performed.
        public static let action = UIColor.blue
    }
    
    /// Appearance of sca related views.
    struct Sca
    {
    }
    
    /// Appearance for likert scale.
    struct LikertScale
    {
        /// Colors associated to the Likert scale.
        struct Color
        {
            public static let negativeTwo   = UIColor.red
            public static let negativeOne   = UIColor.orange
            public static let zero          = UIColor.yellow
            public static let one           = UIColor.blue
            public static let two           = UIColor.green
            
            /// All Likert scale colors.
            public static let all = [ negativeTwo, negativeOne, zero, one, two ]
        }
    }
}
