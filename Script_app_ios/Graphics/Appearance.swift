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
        
        /// The color of table view separator.
        public static let tableViewSeparator = UIColor.lightGray
        
        /// The color for the given SCT type
        public static func color(for type: SctType) -> UIColor
        {
            switch type
            {
            case .diagnostic:
                return UIColor(red: 0 / 255.0, green: 191 / 255.0, blue: 255 / 255.0, alpha: 1.0)
            case .prognostic:
                return UIColor(red: 30 / 255.0, green: 144 / 255.0, blue: 255 / 255.0, alpha: 1.0)
            case .therapeutic:
                return UIColor(red: 100 / 255.0, green: 149 / 255.0, blue: 237 / 255.0, alpha: 1.0)
            }
        }
    }
    
    /// Appearance of SCT related views.
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
            
            /// Tint when selected.
            public static let selected = UIColor.blue.withAlphaComponent(0.3)
            
            /// Tint when correct answer.
            public static let correct = UIColor.green.withAlphaComponent(0.3)
            
            /// Tint when wrong answer.
            public static let wrong = UIColor.red.withAlphaComponent(0.3)
        }
    }
}
