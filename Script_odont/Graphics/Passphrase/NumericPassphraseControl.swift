//
//  PasscodeView.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class NumericPassphraseControl: UITextField
{
    enum VerticalAlign
    {
        case top
        case center
        case bottom
    }
    
    var spacesRatio: CGFloat = 0.5
    var lineWidth: CGFloat = 2.0
    var verticalAlign = VerticalAlign.top
    
    var digitsCount: Int = 6
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    override var text: String? {
        didSet {
            setNeedsDisplay()
        }
    }
    
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
    
    fileprivate func setup_()
    {
        backgroundColor = UIColor.white
        keyboardType = .numberPad
    }
    
    override func drawText(in rect: CGRect)
    {
        draw(rect)
    }
    
    override func drawPlaceholder(in rect: CGRect)
    {
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    
    fileprivate func getY_(rect: CGRect, size: CGFloat) -> CGFloat
    {
        switch verticalAlign
        {
        case .top:
            return lineWidth
        case .center:
            return frame.midY - size / 2
        case .bottom:
            return frame.maxX - size / 2 - lineWidth
        }
    }
    
    override func draw(_ rect: CGRect)
    {
        // clear
        let clearRect = UIBezierPath(rect: frame)
        backgroundColor?.setFill()
        clearRect.fill()
        
        let size = min(frame.size.width * (1 - spacesRatio) / CGFloat(digitsCount), frame.size.height)
        let space = (frame.size.width - size * CGFloat(digitsCount)) / CGFloat(digitsCount - 1)
        let digitPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size, height: size))
        tintColor.setFill()
        tintColor.setStroke()
        digitPath.lineWidth = lineWidth
        
        if let context = UIGraphicsGetCurrentContext()
        {
            let currentText = text ?? ""
            context.saveGState()
            
            let y = getY_(rect: frame, size: size)
            context.translateBy(x: frame.minX + lineWidth, y: y)
            
            for i in 0..<digitsCount
            {
                digitPath.stroke()
                
                if i < currentText.count
                {
                    digitPath.fill()
                }
                
                context.translateBy(x: size + space - lineWidth, y: 0.0)
            }
            
            context.restoreGState()
        }
    }
}
