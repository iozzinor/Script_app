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
    // -------------------------------------------------------------------------
    // MARK: - VERTICAL GRID DISTRIBUTION
    // -------------------------------------------------------------------------
    fileprivate struct VerticalGridDistribution
    {
        let spacing: Int
        let count: Int
    }
    
    // bars
    @IBInspectable var clearColor: UIColor? = nil
    @IBInspectable var barColor: UIColor = UIColor.green
    @IBInspectable var selectedBarColor: UIColor = UIColor.red
    @IBInspectable var barWidthRatio: Double = 0.9
    
    // grid
    @IBInspectable var gridColor: UIColor = UIColor.gray
    @IBInspectable var gridSize: CGFloat = 1.0
    @IBInspectable var gridLinesCount: Int = 4
    @IBInspectable var countWidthRatio: CGFloat = 0.2
    @IBInspectable var topSpaceHeightRatio: CGFloat = 0.1
    @IBInspectable var percentHeightRatio: CGFloat = 0.2
    
    /// This array contains the number of sessions that have a score in an interval.
    /// Score interval (indices of the array) are considered equal.
    /// They range from 0 to 100%.
    var scoresDistribution = [Int]()
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    var selectedBarIndex: Int? = nil
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    fileprivate var maximumScoresCount_: Int {
        return scoresDistribution.max() ?? 1
    }
    
    fileprivate let legendStringAttributes_: [NSAttributedString.Key : Any]? = nil
    
    
    override func draw(_ rect: CGRect)
    {
        // compute sizes
        let countRect = countRect_(rect)
        let barsRect = barsRect_(rect)
        let percentRect = percentRect_(rect)
        
        let distribution = verticalGridDistribution_(linesCount: gridLinesCount)
        
        clearRect_(rect)
        
        drawCount_(in: countRect, distribution: distribution)
        drawGrid_(in: barsRect, distribution: distribution)
        drawBars_(in: barsRect, distribution: distribution)
        drawPercent_(in: percentRect)
    }
    
    override func prepareForInterfaceBuilder()
    {
    }
    
    // -------------------------------------------------------------------------
    // MARK: - RECTANGLE POSITIONS
    // -------------------------------------------------------------------------
    fileprivate func countRect_(_ rect: CGRect) -> CGRect
    {
        let y = rect.height * topSpaceHeightRatio
        let width = rect.width * countWidthRatio
        let height = rect.height * (1.0 - topSpaceHeightRatio - percentHeightRatio)
        
        return CGRect(x: 0.0, y: y, width: width, height: height)
    }
    
    fileprivate func barsRect_(_ rect: CGRect) -> CGRect
    {
        let x = rect.width * countWidthRatio
        let y = rect.height * topSpaceHeightRatio
        let width = rect.width * (1.0 - countWidthRatio)
        let height = rect.height * (1.0 - topSpaceHeightRatio - percentHeightRatio)
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    fileprivate func percentRect_(_ rect: CGRect) -> CGRect
    {
        let x = rect.width * countWidthRatio
        let y = rect.height * (1.0 - percentHeightRatio)
        let width = rect.width * (1.0 - countWidthRatio)
        let height = rect.height * percentHeightRatio
        
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    fileprivate func clearRect_(_ rect: CGRect)
    {
        let clearPath = UIBezierPath(rect: rect)
        (clearColor ?? backgroundColor)?.setFill()
        clearPath.fill()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - POSITIONS
    // -------------------------------------------------------------------------
    fileprivate func verticalGridDistribution_(linesCount: Int) -> VerticalGridDistribution
    {
        let maximum = self.maximumScoresCount_
        
        let tenDivider = 10 * linesCount
        let fiveDivider = 5 * linesCount
        
        if maximum > tenDivider
        {
            return VerticalGridDistribution(spacing: maximum / linesCount / 10 * 10, count: linesCount)
        }
        else if maximum > fiveDivider
        {
            return VerticalGridDistribution(spacing: maximum / linesCount / 5 * 5, count: linesCount)
        }
        
        return VerticalGridDistribution(spacing: maximum / 5 * 5, count: linesCount)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - DRAW
    // -------------------------------------------------------------------------
    fileprivate func drawCount_(in rect: CGRect, distribution: VerticalGridDistribution)
    {
        guard !scoresDistribution.isEmpty else
        {
            return
        }
        
        let max = maximumScoresCount_
        
        let yOffset = CGFloat(max - distribution.count * distribution.spacing) / CGFloat(max) * rect.height
        for i in 0..<distribution.count
        {
            let y = CGFloat(i * distribution.spacing) * rect.height / CGFloat(max) + rect.minY + yOffset
            
            let countString = "\(distribution.spacing * (distribution.count - i))"
            let countSize = countString.size(withAttributes: legendStringAttributes_)
            let countOrigin = CGPoint(x: rect.maxX - countSize.width - 5, y: y - countSize.height / 2.0)
            NSString(string: countString).draw(in: CGRect(origin: countOrigin, size: countSize), withAttributes: legendStringAttributes_)
        }
    }
    
    fileprivate func drawGrid_(in rect: CGRect, distribution: VerticalGridDistribution)
    {
        let linesPath = UIBezierPath()
        linesPath.lineWidth = gridSize
        gridColor.setStroke()
        
        let dashes: [CGFloat] = [10.0, 10.0]
        linesPath.setLineDash(dashes, count: dashes.count, phase: 0)
        
        let max = maximumScoresCount_
        
        let yOffset = CGFloat(max - distribution.count * distribution.spacing) / CGFloat(max) * rect.height
        for i in 0..<distribution.count
        {
            let y = CGFloat(i * distribution.spacing) * rect.height / CGFloat(max) + rect.minY + yOffset
            let startPoint = CGPoint(x: rect.minX, y: y)
            let endPoint = CGPoint(x: rect.maxX, y: y)
            linesPath.move(to: startPoint)
            linesPath.addLine(to: endPoint)
        }
        
        linesPath.stroke()
    }
    
    fileprivate func drawBars_(in rect: CGRect, distribution: VerticalGridDistribution)
    {
        guard !scoresDistribution.isEmpty else
        {
            return
        }
        
        let max = maximumScoresCount_
        let barWidth = CGFloat(barWidthRatio) * rect.width / CGFloat(scoresDistribution.count)
        
        let barSpace = (rect.width - barWidth * CGFloat(scoresDistribution.count)) / CGFloat(scoresDistribution.count)
        var xOffset = rect.minX + barSpace / 2
        let yOffset = CGFloat(max - distribution.count * distribution.spacing) / CGFloat(max) * rect.height + rect.minY
        let height = rect.height - yOffset + rect.minY
        
        for i in 0..<scoresDistribution.count
        {
            if i == selectedBarIndex
            {
                selectedBarColor.setFill()
            }
            else
            {
                barColor.setFill()
            }
            
            let x = xOffset
            xOffset += barSpace + barWidth
            let barHeight = height * CGFloat(scoresDistribution[i]) / CGFloat(max)
            let y =  yOffset + height - barHeight
            
            let barRect = CGRect(x: x, y: y, width: barWidth, height: barHeight)
            
            let barPath = UIBezierPath(rect: barRect)
            barPath.fill()
        }
    }
    
    fileprivate func drawPercent_(in rect: CGRect)
    {
        guard !scoresDistribution.isEmpty else
        {
                return
        }
        
        let percentRangeWidth = rect.width / CGFloat(scoresDistribution.count)
        
        for i in 0..<(scoresDistribution.count - 1)
        {
            let rangeCenterX = percentRangeWidth * (CGFloat(i) + 1.0) + rect.minX
            
            // percent label
            let percent = Int(Double(i + 1) * 100.0 / Double(scoresDistribution.count))
            let percentString = "\(percent)"
            
            let currentStringSize = percentString.size(withAttributes: legendStringAttributes_)
            let x = rangeCenterX - currentStringSize.width / 2
            let y = rect.minY + (rect.height - currentStringSize.height) / 2
            let stringRect = CGRect(x: x, y: y, width: currentStringSize.width, height: currentStringSize.height)
            
            NSString(string: percentString).draw(in: stringRect, withAttributes: legendStringAttributes_)
            
            // percent indicator
            let percentRect = CGRect(x: rangeCenterX, y: rect.minY, width: 2, height: min(10.0, rect.height / 10.0))
            UIColor.gray.setFill()
            let indicatorPath = UIBezierPath(rect: percentRect)
            indicatorPath.fill()
        }
    }
}
