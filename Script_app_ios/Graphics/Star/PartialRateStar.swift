//
//  PartialRateStar.swift
//  Script_odont
//
//  Created by Régis Iozzino on 12/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

@IBDesignable
class PartialRateStar: UIView
{
    fileprivate var borderLayer_ = CAShapeLayer()
    fileprivate var fillLayer_   = CAShapeLayer()
    
    @IBInspectable var lineWidth: CGFloat = 2
    @IBInspectable var innerRatio: CGFloat = 0.5 {
        didSet {
            if !Constants.inRange(innerRatio, min: 0.0, max: 1.0)
            {
                innerRatio = Constants.bound(innerRatio, min: 0.0, max: 1.0)
            }
            
            updateStarLayers_()
        }
    }
    @IBInspectable var outerRatio: CGFloat = 1.0
    
        {
        didSet {
            if !Constants.inRange(outerRatio, min: 0.0, max: 1.0)
            {
                outerRatio = Constants.bound(outerRatio, min: 0.0, max: 1.0)
            }
            
            updateStarLayers_()
        }
    }
    @IBInspectable var starPoints: Int = 5
    {
        didSet {
            if starPoints < 1
            {
                starPoints = 1
            }
        }
    }
    @IBInspectable var starColor: UIColor = UIColor.blue
    
    @IBInspectable var value: Double = 0.5
    {
        didSet {
            if !Constants.inRange(value, min: 0.0, max: 1.0)
            {
                value = Constants.bound(value, min: 0.0, max: 1.0)
            }
            
            updateFillLayerMask_()
        }
    }
    
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
    
    fileprivate func setup_()
    {
        layer.addSublayer(borderLayer_)
        layer.addSublayer(fillLayer_)
        
        updateStarLayers_()
    }
    
    override func layoutSubviews()
    {
        updateStarLayers_()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - LAYER
    // -------------------------------------------------------------------------
    fileprivate func updateStarLayers_()
    {
        // size
        let starFrame = starFrame_()
        borderLayer_.frame = starFrame
        fillLayer_.frame = starFrame
        
        // path
        let starPath = starPath_(layerFrame: borderLayer_.bounds)
        borderLayer_.path   = starPath.cgPath
        fillLayer_.path     = starPath.cgPath
        
        // update paths
        updateBorderLayerPath_()
        updateFillLayerPath_()
    }
    
    fileprivate func updateBorderLayerPath_()
    {
        borderLayer_.fillColor = nil
        borderLayer_.strokeColor = starColor.cgColor
        borderLayer_.lineWidth = lineWidth
    }
    
    fileprivate func updateFillLayerPath_()
    {
        fillLayer_.fillColor = starColor.cgColor
        fillLayer_.strokeColor = nil
        fillLayer_.lineWidth = 0
        
        updateFillLayerMask_()
    }
    
    fileprivate func updateFillLayerMask_()
    {
        let width = fillLayer_.frame.width * CGFloat(value)
        let maskLayer = CALayer()
        maskLayer.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: fillLayer_.frame.height))
        maskLayer.backgroundColor = UIColor.black.cgColor
        fillLayer_.mask = maskLayer
    }
    
    // -------------------------------------------------------------------------
    // MARK: - PATHS
    // -------------------------------------------------------------------------
    fileprivate func starFrame_() -> CGRect
    {
        let size = min(bounds.size.width, bounds.size.height)
        return CGRect(x: (bounds.size.width - size) / 2, y: (bounds.size.height - size) / 2, width: size, height: size)
    }
    
    fileprivate func starPath_(layerFrame: CGRect) -> UIBezierPath
    {
        let size = min(layerFrame.size.width, layerFrame.size.height)
        let center = CGPoint(x: layerFrame.midX, y: layerFrame.midY)
        let maxRadius = size / 2
        let innerRadius = innerRatio * maxRadius
        let outerRadius = outerRatio * maxRadius
        
        return UIBezierPath(starCenter: center, innerRadius: innerRadius, outerRadius: outerRadius, points: starPoints)
    }
}
