//
//  RateStartView.swift
//  Script_odont
//
//  Created by Régis Iozzino on 12/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

@IBDesignable
class RateStartView: UIView
{
    public static let starAnimationDuration = 0.5
    public static let diskAnimationDuration = 0.25
    
    @IBInspectable var innerRatio: CGFloat = 0.5
    @IBInspectable var outerRatio: CGFloat = 1.0
    @IBInspectable var starPoints = 5
    @IBInspectable var starColor = UIColor.blue
    
    @IBInspectable var selected = true
    {
        didSet
        {
            if selected != oldValue
            {
                toggleSelection_()
            }
        }
    }
    
    fileprivate var mainLayer_ = CAShapeLayer()
    fileprivate var isAnimating_ = false
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    
        setup_()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        setup_()
    }
    
    override func prepareForInterfaceBuilder()
    {
        updateMainLayer_()
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        updateMainLayer_()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setup_()
    {
        layer.addSublayer(mainLayer_)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RateStartView.toggle_)))
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @objc fileprivate func toggle_(_ sender: UITapGestureRecognizer)
    {
        guard !isAnimating_ else
        {
            return
        }
        selected = !selected
    }
    
    fileprivate func toggleSelection_()
    {
        isAnimating_ = true
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.updateMainLayer_()
            self.isAnimating_ = false
        })
        addToggleAnimation_()
        CATransaction.commit()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - LAYER
    // -------------------------------------------------------------------------
    fileprivate func updateMainLayer_()
    {
        // update the size
        let layerFrame = layerFrame_()
        mainLayer_.frame = layerFrame
        
        // draw the path
        mainLayer_.fillColor = starColor.cgColor
        mainLayer_.strokeColor = nil
        mainLayer_.lineWidth = 0
        
        let path: UIBezierPath
        if selected
        {
            path = selectedPath_(layerFrame: layerFrame)
        }
        else
        {
            path = diskPath_(layerFrame: layerFrame)
        }
            
        mainLayer_.path = path.cgPath
    }
    
    // -------------------------------------------------------------------------
    // MARK: - PATHS
    // -------------------------------------------------------------------------
    fileprivate func layerFrame_() -> CGRect
    {
        return CGRect(origin: CGPoint.zero, size: bounds.size)
    }
    
    fileprivate func selectedPath_(layerFrame: CGRect) -> UIBezierPath
    {
        let size = min(layerFrame.size.width, layerFrame.size.height)
        let center = CGPoint(x: layerFrame.midX, y: layerFrame.midY)
        let angle = CGFloat.pi / CGFloat(starPoints)
        let maxRadius = size / 2
        let innerRadius = innerRatio * maxRadius
        let outerRadius = outerRatio * maxRadius
        
        let path = UIBezierPath()
        
        for i in 0..<(starPoints * 2)
        {
            let currentAngle = angle * CGFloat(i)
            let radius = (i % 2 == 1 ? innerRadius : outerRadius)
            
            let x = center.x + radius * cos(currentAngle)
            let y = center.y + radius * sin(currentAngle)
            let point = CGPoint(x: x, y: y)
            
            if i == 0
            {
                path.move(to: point)
            }
            else
            {
                path.addLine(to: point)
            }
        }
        path.close()
        
        var rotation = CGAffineTransform.identity
        rotation = rotation.translatedBy(x: center.x, y: center.y)
        rotation = rotation.rotated(by: -CGFloat.pi / 2)
        rotation = rotation.translatedBy(x: -center.x, y: -center.y)
        path.apply(rotation)
        
        return path
    }
    
    fileprivate func unselectedPath_(layerFrame: CGRect) -> UIBezierPath
    {
        let center = CGPoint(x: layerFrame.midX, y: layerFrame.midY)
        let path = UIBezierPath()
        
        for i in 0..<(starPoints * 2)
        {
            if i == 0
            {
                path.move(to: center)
            }
            else
            {
                path.addLine(to: center)
            }
        }
        
        return path
    }
    
    fileprivate func diskPath_(layerFrame: CGRect) -> UIBezierPath
    {
        let size = min(layerFrame.size.width, layerFrame.size.height) * 0.2
        let diskFrame = CGRect(x: (layerFrame.size.width - size) / 2,
                               y: (layerFrame.size.height - size) / 2,
                               width: size,
                               height: size)
        return UIBezierPath(ovalIn: diskFrame)
    }
    
    
    // -------------------------------------------------------------------------
    // MARK: - ANIMATION
    // -------------------------------------------------------------------------
    fileprivate func addToggleAnimation_()
    {
        if selected
        {
            addDiskToggleAnimation_(select: true, beginTime: 0.0)
            addStarToggleAnimation_(select: true, beginTime: RateStartView.diskAnimationDuration)
        }
        else
        {
            addStarToggleAnimation_(select: false, beginTime: 0.0)
            addDiskToggleAnimation_(select: false, beginTime: RateStartView.starAnimationDuration)
        }
    }
    
    fileprivate func addStarToggleAnimation_(select: Bool, beginTime: Double)
    {
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = RateStartView.starAnimationDuration
        animation.beginTime = CACurrentMediaTime() + beginTime
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        if select
        {
            animation.fromValue = unselectedPath_(layerFrame: layerFrame_()).cgPath
            animation.toValue   = selectedPath_(layerFrame: layerFrame_()).cgPath
        }
        else
        {
            animation.fromValue = selectedPath_(layerFrame: layerFrame_()).cgPath
            animation.toValue   = unselectedPath_(layerFrame: layerFrame_()).cgPath
        }
        animation.repeatCount = 1
        
        mainLayer_.add(animation, forKey: "StarSelection")
    }
    
    fileprivate func addDiskToggleAnimation_(select: Bool, beginTime: Double)
    {
        let diskPath = diskPath_(layerFrame: layerFrame_())
        mainLayer_.path = diskPath.cgPath
        
        func animation(keyPath: String) -> CABasicAnimation
        {
            let diskAnimation = CABasicAnimation(keyPath: keyPath)
            diskAnimation.duration = RateStartView.diskAnimationDuration
            diskAnimation.beginTime = CACurrentMediaTime() + beginTime
            if select
            {
                diskAnimation.fromValue = 1
                diskAnimation.toValue = 0
            }
            else
            {
                diskAnimation.fromValue = 0
                diskAnimation.toValue = 1
            }
            return diskAnimation
        }
        
        let diskAnimationX = animation(keyPath: "transform.scale.x")
        let diskAnimationY = animation(keyPath: "transform.scale.y")
        
        mainLayer_.add(diskAnimationX, forKey: "DiskSelectionX")
        mainLayer_.add(diskAnimationY, forKey: "DiskSelectionY")
    }
}
