//
//  SctScoreDiagram.swift
//  Script_odont
//
//  Created by Régis Iozzino on 13/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

@IBDesignable
class SctScoreDiagram: UIView
{
    @IBInspectable var clearColor: UIColor? = nil
    @IBInspectable var barColor: UIColor = UIColor.green
    @IBInspectable var selectedBarColor: UIColor = UIColor.red
    @IBInspectable var gridColor: UIColor = UIColor.gray
    @IBInspectable var gridSize: CGFloat = 2.0
    
    override func draw(_ rect: CGRect)
    {
        // clear the rect
        let clearPath = UIBezierPath(rect: rect)
        (clearColor ?? backgroundColor)?.setFill()
        clearPath.fill()
    }
}
