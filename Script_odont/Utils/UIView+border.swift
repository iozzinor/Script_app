//
//  UIView+border.swift
//  Script_odont
//
//  Created by Régis Iozzino on 08/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

extension UIView
{
    enum BorderPosition
    {
        case top
        case bottom
        case right
        case left
    }
    
    func addBorder(with color: UIColor, lineWidth: CGFloat, position: BorderPosition)
    {
        let borderView = UIView()
        borderView.backgroundColor = color
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(borderView)
        
        var borderConstraints = [NSLayoutConstraint]()
        switch position
        {
        case .top, .bottom:
            borderConstraints.append(NSLayoutConstraint(item: borderView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: lineWidth))
            
            borderConstraints.append(NSLayoutConstraint(item: borderView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0))
            borderConstraints.append(NSLayoutConstraint(item: borderView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0))
        case .right, .left:
            borderConstraints.append(NSLayoutConstraint(item: borderView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: lineWidth))
            
            borderConstraints.append(NSLayoutConstraint(item: borderView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
            borderConstraints.append(NSLayoutConstraint(item: borderView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        }
        
        switch position
        {
        case .top:
            borderConstraints.append(NSLayoutConstraint(item: borderView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0))
        case .bottom:
            borderConstraints.append(NSLayoutConstraint(item: borderView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        case .right:
            borderConstraints.append(NSLayoutConstraint(item: borderView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0))
        case .left:
            borderConstraints.append(NSLayoutConstraint(item: borderView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0))
        }
        
        addConstraints(borderConstraints)
    }
    
    func addBorders(with color: UIColor, lineWidth: CGFloat, positions: [BorderPosition])
    {
        for position in positions
        {
            addBorder(with: color, lineWidth: lineWidth, position: position)
        }
    }
}
