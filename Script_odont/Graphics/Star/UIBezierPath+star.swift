//
//  UIBezierPath+star.swift
//  Script_odont
//
//  Created by Régis Iozzino on 12/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

extension UIBezierPath
{
    convenience init(starCenter: CGPoint, innerRadius: CGFloat, outerRadius: CGFloat, points: Int)
    {
        self.init()
        
        let starPoints = (points > 0 ? points : 5)
        
        let angle = CGFloat.pi / CGFloat(starPoints)
        
        for i in 0..<(starPoints * 2)
        {
            let currentAngle = angle * CGFloat(i)
            let radius = (i % 2 == 1 ? innerRadius : outerRadius)
            
            let x = starCenter.x + radius * cos(currentAngle)
            let y = starCenter.y + radius * sin(currentAngle)
            let point = CGPoint(x: x, y: y)
            
            if i == 0
            {
                move(to: point)
            }
            else
            {
                addLine(to: point)
            }
        }
        close()
        
        var rotation = CGAffineTransform.identity
        rotation = rotation.translatedBy(x: starCenter.x, y: starCenter.y)
        rotation = rotation.rotated(by: -CGFloat.pi / 2)
        rotation = rotation.translatedBy(x: -starCenter.x, y: -starCenter.y)
        apply(rotation)
    }
}
