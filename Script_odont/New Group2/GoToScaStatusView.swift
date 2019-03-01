//
//  GoToScaStatus.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class GoToScaStatusView: UIView
{
    var isValid: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var radiusRatio: CGFloat = 0.8
    @IBInspectable var lineRatio: CGFloat = 0.1
    
    override func draw(_ rect: CGRect)
    {
        // clear
        UIColor.white.setFill()
        let clearPath = UIBezierPath(rect: rect)
        clearPath.fill()
        
        // draw the circle
        let size = min(rect.width, rect.height) * radiusRatio
        let circleRect = CGRect(x: (rect.width - size) / 2, y: (rect.height - size) / 2, width: size, height: size)
        
        let circlePath = UIBezierPath(roundedRect: circleRect, cornerRadius: size / 2)
        
        
        if isValid
        {
            UIColor.green.setStroke()
            UIColor.green.setFill()
        }
        else
        {
            circlePath.lineWidth = size * lineRatio
            UIColor.gray.setStroke()
        }
        
        circlePath.stroke()
        circlePath.fill()
    }
}
