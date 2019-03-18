//
//  ScoreProgressDiagram.swift
//  Script_odont
//
//  Created by Régis Iozzino on 17/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

@IBDesignable
class ScoreProgressDiagram: UIView
{
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        setup_()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setup_()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setup_()
    {
    }
}
