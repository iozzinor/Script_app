//
//  BorderView.swift
//  Script_odont
//
//  Created by Régis Iozzino on 22/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

/// A view that act as a border.
class BorderView: UIView
{
    /// The border positions.
    enum Position
    {
        /// Top position.
        case top
        
        /// Bottom position.
        case bottom
    
        /// Right position.
        case right
        
        /// Left position.
        case left
        
        /// An array of all the positions.
        static let all: [Position] = [.top, .bottom, .right, .left]
    }

    /// The current position.
    var position = Position.top
    
    /// Create a border.
    ///
    /// - parameter position: The view position.
    convenience init(position: Position)
    {
        self.init()
        self.position = position
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}
