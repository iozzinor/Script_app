//
//  BorderView.swift
//  Script_odont
//
//  Created by Régis Iozzino on 22/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class BorderView: UIView
{
    enum Position
    {
        case top
        case bottom
        case right
        case left
        
        static let all: [Position] = [.top, .bottom, .right, .left]
    }

    var position = Position.top
    
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
