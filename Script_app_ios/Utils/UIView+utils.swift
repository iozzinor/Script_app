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
    /// Add a border to the current view.
    ///
    /// The border is a rectangular view, deriving from the UIView class.
    /// It is added as a child to the current view.
    ///
    /// - parameter color: The border color.
    /// - parameter lineWidth: The border width.
    /// - parameter position: The border position.
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
    
    /// Add serveral borders to the current view.
    ///
    /// - parameter color: Borders color.
    /// - parameter lineWidth: Borders width.
    /// - parameter positions: Borders positions.
    func addBorders(with color: UIColor, lineWidth: CGFloat, positions: [BorderView.Position])
    {
        for position in positions
        {
            addBorder(with: color, lineWidth: lineWidth, position: position)
        }
    }
    
    /// Remove borders for the given positions.
    ///
    /// - parameter positions: The positions for which borders will be removed.
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
    
    /// Find a border with position `position`.
    fileprivate func findBorder_(for position: BorderView.Position) -> BorderView?
    {
        return subviews.map { $0 as? BorderView}.first(where: { $0 != nil && $0!.position == position}) ?? nil
    }
    
    /// The top border if it exists.
    var topBorder: BorderView? {
        return findBorder_(for: .top)
    }
    /// The bottom border if it exists.
    var bottomBorder: BorderView? {
        return findBorder_(for: .bottom)
    }
    /// The right border if it exists.
    var rightBorder: BorderView? {
        return findBorder_(for: .right)
    }
    /// The left border if it exists.
    var leftBorder: BorderView? {
        return findBorder_(for: .left)
    }
    
    /// Borders of the current view.
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
    /// Add a subview to the current one.
    ///
    /// The new subview will have constraints to measure the same size as the
    /// current one.
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
    
    /// Adjust a subview that is alrready part of the current view hierarchy.
    func adjustSubview(_ subview: UIView)
    {
        guard subviews.contains(subview) else
        {
            return
        }
        addSubviewAdjusting(subview)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ERROR SHAKE
    // -------------------------------------------------------------------------
    /// Make an error shake animation.
    ///
    /// The view translates from left to right back and forth for 1 second.
    func animateErrorShake()
    {
        self.transform = CGAffineTransform(translationX: 10, y: 0)
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 4.0, options: [], animations: {
            self.transform = CGAffineTransform.identity
        })
    }
}
