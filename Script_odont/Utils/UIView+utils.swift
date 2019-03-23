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
    // -------------------------------------------------------------------------
    // MARK: - BORDER
    // -------------------------------------------------------------------------
    func addBorder(with color: UIColor, lineWidth: CGFloat, position: BorderView.Position)
    {
        let borderView = BorderView(position: position)
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
    
    func addBorders(with color: UIColor, lineWidth: CGFloat, positions: [BorderView.Position])
    {
        for position in positions
        {
            addBorder(with: color, lineWidth: lineWidth, position: position)
        }
    }
    
    func removeBorders(_ positions: [BorderView.Position] = BorderView.Position.all)
    {
        guard !subviews.isEmpty else
        {
            return
        }
        
        let viewsCount = subviews.count
        for i in 0..<viewsCount
        {
            let index = viewsCount - i - 1
            if let currentBorder = subviews[index] as? BorderView,
                positions.contains(currentBorder.position)
            {
                currentBorder.removeFromSuperview()
            }
        }
    }
    
    fileprivate func findBorder_(for position: BorderView.Position) -> BorderView?
    {
        return subviews.map { $0 as? BorderView}.first(where: { $0 != nil && $0!.position == position}) ?? nil
    }
    
    var topBorder: BorderView? {
        return findBorder_(for: .top)
    }
    var bottomBorder: BorderView? {
        return findBorder_(for: .bottom)
    }
    var rightBorder: BorderView? {
        return findBorder_(for: .right)
    }
    var leftBorder: BorderView? {
        return findBorder_(for: .left)
    }
    
    var borders: [BorderView] {
        var result = [BorderView]()
        for subview in subviews
        {
            if let border = subview as? BorderView
            {
                result.append(border)
            }
        }
        return result
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ADAPT
    // -------------------------------------------------------------------------
    func addSubviewAdjusting(_ subview: UIView)
    {
        func makeConstraint(first: UIView, second: UIView, attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint
        {
            return NSLayoutConstraint(item: first, attribute: attribute, relatedBy: .equal, toItem: second, attribute: attribute, multiplier: 1.0, constant: 0.0)
        }
        
        if !subviews.contains(subview)
        {
            self.addSubview(subview)
        }
        
        let top     = makeConstraint(first: self, second: subview, attribute: .top)
        let right   = makeConstraint(first: self, second: subview, attribute: .right)
        let left    = makeConstraint(first: self, second: subview, attribute: .left)
        let bottom  = makeConstraint(first: self, second: subview, attribute: .bottom)
        
        self.addConstraints([top, right, left, bottom])
    }
    
    func adjustSubview(_ subview: UIView)
    {
        guard subviews.contains(subview) else
        {
            return
        }
        addSubviewAdjusting(subview)
    }
}
