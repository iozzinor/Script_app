//
//  DetailFotter.swift
//  Script_odont
//
//  Created by Régis Iozzino on 17/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class DetailFooter: UIView
{
    static let defaultHeight: CGFloat = 1.0
    static let defaultWidthRatio: CGFloat = 0.8
    static let defaultBackgroundColor = Appearance.Color.tableViewSeparator
    
    fileprivate var maskLayer_: CALayer? = nil
    
    var height = DetailFooter.defaultHeight
    var widthRatio = DetailFooter.defaultWidthRatio
    
    var color: UIColor {
        get {
            
            if let layerColor = maskLayer_?.backgroundColor
            {
                return UIColor(cgColor: layerColor)
            }
            return DetailFooter.defaultBackgroundColor
        }
        set {
            maskLayer_?.backgroundColor = newValue.cgColor
        }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setupMaskLayer_()
    }

    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        setupMaskLayer_()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setupMaskLayer_()
    {
        maskLayer_ = CALayer()
        
        layer.addSublayer(maskLayer_!)
        
        color = DetailFooter.defaultBackgroundColor
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UPDATE SIZE
    // -------------------------------------------------------------------------
    func updateSize(forWidth width: CGFloat)
    {
        let newMaskWidth = DetailFooter.defaultWidthRatio * width
        let x = (width - newMaskWidth) / 2
        
        maskLayer_?.frame = CGRect(x: x, y: 0, width: newMaskWidth, height: height)
        layer.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height))
    }
}
