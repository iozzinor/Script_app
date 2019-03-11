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
        
        /// The default color to use to indicate an error occured.
        public static let error = UIColor.red
        
        /// The default color to use to indicate the correct answer has been selected.
        public static let correct = UIColor.green
        
        /// The missing color.
        public static let missing = UIColor.gray
        
        /// The color used to indicate an action might be performed.
        public static let action = UIColor.blue
        
        /// The color for the given topic
        public static func color(for topic: SctTopic) -> UIColor
        {
            switch topic
            {
            case .diagnostic:
                return UIColor.yellow
            case .prognostic:
                return UIColor.red
            case .therapeutic:
                return UIColor.blue
            }
        }
    }
    
    /// Appearance of sct related views.
    struct SctHorizontal
    {
        struct Table
        {
            public static let borderColor = UIColor.black
            public static let borderWidth: CGFloat = 2.0
        }
    }
    
    /// Appearance for likert scale.
    struct LikertScale
    {
        /// Colors associated to the Likert scale.
        struct Color
        {
            public static let `default` = UIColor.black
            public static let selected = UIColor.blue
        }
    }
}
