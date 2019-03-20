//
//  ScoreProgressDiagram.swift
//  Script_odont
//
//  Created by Régis Iozzino on 17/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

@IBDesignable
class ScoreProgressDiagram: UIView
{
    // -------------------------------------------------------------------------
    // MARK: - SCORE POINT
    // -------------------------------------------------------------------------
    /// A score point.
    ///
    /// It describes the position of a score.
    struct ScorePoint
    {
        /// The score.
        ///
        /// It represents the ordinates of the point.
        /// It should be included in the interval `[0.0; 100.0]`.
        var score: Double
        
        /// The time.
        ///
        /// It represents the abscissa of the point.
        /// It should be included in the interval `[0.0; 100.0]`.
        var time: Double
    }
    
    // -------------------------------------------------------------------------
    // MARK: - DIAGRAM TYPE
    // -------------------------------------------------------------------------
    @objc enum DiagramType: Int, CaseIterable
    {
        case fill
        case line
    }
    
    // -------------------------------------------------------------------------
    // MARK: - HORIZONTAL SEPARATION
    // -------------------------------------------------------------------------
    fileprivate struct HorizontalSeparation
    {
        var title: String?
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SECTION
    // -------------------------------------------------------------------------
    fileprivate struct Section
    {
        var title: String?
    }
    
    // -------------------------------------------------------------------------
    // MARK: - PROGRESS DATA
    // -------------------------------------------------------------------------
    fileprivate struct ProgressData
    {
        var horizontalSeparations: [HorizontalSeparation]
        var sections:              [Section]
        var subsections:           Int
        var scores:                [ScorePoint]
        
        var ordinatesAxisTitle: String
        
        var horizontalSeparationDashPattern: DashPattern
        var sectionDashPattern: DashPattern
        var subsectionDashPattern: DashPattern
        
        init()
        {
            self.horizontalSeparations = []
            self.sections = []
            self.subsections = 0
            self.scores = []
            
            self.ordinatesAxisTitle = ""
            
            self.horizontalSeparationDashPattern = ScoreProgressDiagram.defaultHorizontalDashPattern
            self.sectionDashPattern = ScoreProgressDiagram.defaultSectionDashPattern
            self.subsectionDashPattern = ScoreProgressDiagram.defaultSubsectionDashPattern
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - DEFAULT VALUES
    // -------------------------------------------------------------------------
    fileprivate static let defaultOrdinatesAxisTitleWidthRatio_: CGFloat = 0.1
    fileprivate static let defaultOrdinatesAxisLegendWidthRatio_: CGFloat = 0.1
    fileprivate static let defaultSectionsHeightRatio: CGFloat = 0.1
    
    fileprivate static let defaultHorizontalDashPattern = DashPattern(alternateLengths: [4.0, 0.0], phase: 0.0)
    fileprivate static let defaultHorizontalSeparationsCount = 5
    fileprivate static let defaultSectionDashPattern = DashPattern(alternateLengths: [4.0, 1.0], phase: 0.0)
    fileprivate static let defaultSubsectionDashPattern = DashPattern(alternateLengths: [2.0, 1.0], phase: 0.0)
    
    @IBInspectable var clearColor: UIColor = UIColor.white
    
    // ordinates title
    @IBInspectable var ordinatesAxisTitleColor: UIColor = UIColor.gray

    // legend title
    @IBInspectable var legendTitleColor: UIColor = UIColor.gray
    @IBInspectable var legendRightPadding: CGFloat = 5.0
    
    // ordinates axis
    @IBInspectable var ordinatesAxisColor: UIColor = UIColor.darkGray
    @IBInspectable var ordinatesAxisWidth: CGFloat = 2.0
    
    // horizontal separation
    @IBInspectable var horizontalSeparationsColor: UIColor = UIColor.gray
    @IBInspectable var horizontalSeparationsWidth: CGFloat = 0.2
    
    // abscissa axis
    @IBInspectable var abscissaAxisColor: UIColor = UIColor.gray
    @IBInspectable var abscissaAxisHeight: CGFloat = 1.0
    
    // section
    @IBInspectable var sectionLineColor: UIColor = UIColor.lightGray
    @IBInspectable var sectionLineWidth: CGFloat = 1.0
    
    // section title
    @IBInspectable var sectionTitleColor: UIColor = UIColor.gray
    @IBInspectable var sectionTitleLeftPadding: CGFloat = 2.0
    
    // subsection
    @IBInspectable var subsectionLineColor: UIColor = UIColor.lightGray
    @IBInspectable var subsectionLineWidth: CGFloat = 0.5
    
    // score point
    @IBInspectable var scorePointColor: UIColor = UIColor.blue
    @IBInspectable var scorePointSize: CGFloat = 5.0
    @IBInspectable var scorePointLineWidth: CGFloat = 2.0
    
    // diagram
    @IBInspectable var diagramType: DiagramType = DiagramType.fill
    @IBInspectable var diagramTopGradientColor: UIColor = UIColor.blue.withAlphaComponent(0.2)
    @IBInspectable var diagramBottomGradientColor: UIColor = UIColor.blue.withAlphaComponent(0.6)
    @IBInspectable var diagramStrokeColor: UIColor = UIColor.blue
    @IBInspectable var diagramStrokeWidth: CGFloat = 2.0
    
    weak var delegate: ScoreProgressDiagramDelegate? = nil
    weak var dataSource: ScoreProgressDiagramDataSource? = nil
    {
        didSet
        {
            reloadData()
        }
    }
    
    fileprivate var progressData_ = ProgressData()
    
    fileprivate var ordinatesAxisTitleFontAttributes_: [NSAttributedString.Key: Any] {
        var result = [NSAttributedString.Key: Any]()
        
        // color
        result[NSAttributedString.Key.foregroundColor] = ordinatesAxisTitleColor
        
        return result
    }
    fileprivate var legendFontAttributes_: [NSAttributedString.Key: Any] {
        var result = [NSAttributedString.Key: Any]()
        
        // color
        result[NSAttributedString.Key.foregroundColor] = legendTitleColor
        
        return result
    }
    fileprivate var sectionFontAttributes_: [NSAttributedString.Key: Any] {
        var result = [NSAttributedString.Key: Any]()
        
        // color
        result[NSAttributedString.Key.foregroundColor] = sectionTitleColor
        
        return result
    }
    
    // -------------------------------------------------------------------------
    // MARK: - DATA
    // -------------------------------------------------------------------------
    func reloadData()
    {
        progressData_ = retrieveData_()
        setNeedsDisplay()
    }
    
    fileprivate func retrieveData_() -> ProgressData
    {
        var result = ProgressData()
        if let dataSource = dataSource
        {
            result.ordinatesAxisTitle = dataSource.ordinatesAxisTitle(for: self)
            
            // horizontal separations
            let horizontalSeparationsCount = dataSource.numberOfHorizontalSeparations(in: self)
            for i in 0..<horizontalSeparationsCount
            {
                let newHorizontalSeparationTitle = dataSource.scoreProgressDiagram(self, titleForHorizontalSeparation: i)
                let newHorizontalSeparation = HorizontalSeparation(title: newHorizontalSeparationTitle)
                result.horizontalSeparations.append(newHorizontalSeparation)
            }
            
            // sections
            let sectionsCount = dataSource.numberOfSections(in: self)
            for i in 0..<sectionsCount
            {
                let newSectionTitle = dataSource.scoreProgressDiagram(self, titleForSection: i)
                let newSection = Section(title: newSectionTitle)
                result.sections.append(newSection)
            }
            
            // subsections
            result.subsections = dataSource.numberOfSubsections(in: self)
            
            // scores
            let scoresCount = dataSource.numberOfScores(for: self)
            for i in 0..<scoresCount
            {
                let newScore = dataSource.scoreProgressDiagram(self, scoreForTime: i)
                result.scores.append(newScore)
            }
        }
        
        if let delegate = delegate
        {
            result.horizontalSeparationDashPattern = delegate.horizontalSeparationDashPattern(for: self)
            result.sectionDashPattern = delegate.sectionDashPattern(for: self)
            result.subsectionDashPattern = delegate.subsectionDashPattern(for: self)
        }
        
        return result
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SIZES
    // -------------------------------------------------------------------------
    fileprivate func ordinatesAxisTitleRect_(_ rect: CGRect) -> CGRect
    {
        let ordinatesAxisTitleWidth: CGFloat
        if delegate != nil
        {
            ordinatesAxisTitleWidth = delegate!.ordinatesAxisTitleWidth(for: self)
        }
        else
        {
            ordinatesAxisTitleWidth = rect.width * ScoreProgressDiagram.defaultOrdinatesAxisTitleWidthRatio_
        }
        
        return CGRect(x: rect.minX, y: rect.minY, width: ordinatesAxisTitleWidth, height: rect.height)
    }
    
    fileprivate func sectionHeight_(_ rect: CGRect) -> CGFloat
    {
        if delegate != nil
        {
            return delegate!.sectionHeight(for: self)
        }
        else
        {
            return rect.height * ScoreProgressDiagram.defaultSectionsHeightRatio
        }
    }
    
    fileprivate func ordinatesAxisLegendRect_(forOrdinatesAxisTitleRect ordinatesAxisTitleRect: CGRect, rect: CGRect, sectionHeight: CGFloat) -> CGRect
    {
        let ordinatesAxisLegendWidth: CGFloat
        if delegate != nil
        {
            ordinatesAxisLegendWidth = delegate!.ordinatesAxisLegendWidth(for: self)
        }
        else
        {
            ordinatesAxisLegendWidth = rect.width * ScoreProgressDiagram.defaultOrdinatesAxisLegendWidthRatio_
        }
        
        return CGRect(x: ordinatesAxisTitleRect.maxX + rect.minX, y: rect.minY, width: ordinatesAxisLegendWidth, height: rect.height - sectionHeight)
    }
    
    fileprivate func gridRect_(forOrdinatesAxisLegendRect ordinatesAxisLegendRect: CGRect, rect: CGRect) -> CGRect
    {
        return CGRect(x: rect.minX + ordinatesAxisLegendRect.maxX, y: rect.minY, width: rect.width - ordinatesAxisLegendRect.maxX, height: rect.height)
    }
    
    fileprivate func sectionsRect_(forGridRect gridRect: CGRect, sectionHeight: CGFloat) -> CGRect
    {
        return CGRect(x: gridRect.minX, y: gridRect.maxY - sectionHeight, width: gridRect.width, height: sectionHeight)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - DRAW
    // -------------------------------------------------------------------------
    override func draw(_ rect: CGRect)
    {
        let ordinatesAxisTitleRect = ordinatesAxisTitleRect_(bounds)
        let sectionHeight = sectionHeight_(bounds)
        let ordinatesAxisLegendRect = ordinatesAxisLegendRect_(forOrdinatesAxisTitleRect: ordinatesAxisTitleRect, rect: bounds, sectionHeight: sectionHeight)
        let gridRect = gridRect_(forOrdinatesAxisLegendRect: ordinatesAxisLegendRect, rect: bounds)
        let sectionsRect = sectionsRect_(forGridRect: gridRect, sectionHeight: sectionHeight)
        
        drawClear_(bounds)
        
        // ordinates axis
        drawOrdinatesAxisTitle_(ordinatesAxisTitleRect)
        drawOrdinatesAxisLegend_(ordinatesAxisLegendRect)
        drawOrdinatesAxis_(forGridRect: gridRect)
        
        // horizontal separations
        drawHorizontalSeparations_(gridRect,
                                   sectionHeight: sectionHeight,
                                   count: progressData_.horizontalSeparations.count,
                                   dashPattern: progressData_.horizontalSeparationDashPattern)
        drawAbscissaAxis_(forSectionsRect: sectionsRect)
        
        // sections
        drawSections_(forGridRect: gridRect, sectionHeight: sectionHeight)
        drawSectionTitles_(rect: sectionsRect)
        drawSubsections_(forGridRect: gridRect, sectionHeight: sectionHeight)
        
        // diagram
        drawDiagram_(forGridRect: gridRect, sectionHeight: sectionHeight)
    }
    
    fileprivate func drawClear_(_ rect: CGRect)
    {
        clearColor.setFill()
        
        let clearPath = UIBezierPath(rect: rect)
        clearPath.fill()
    }
    
    fileprivate func drawOrdinatesAxisTitle_(_ rect: CGRect)
    {
        let fontAttributes = ordinatesAxisTitleFontAttributes_
        
        let title = NSString(string: progressData_.ordinatesAxisTitle)
        let size = title.size(withAttributes: fontAttributes)
        
        let titleRect = CGRect(x: (rect.width - size.height) / 2 + rect.minX, y: rect.minY, width: size.height, height: size.width)
        
        if let context = UIGraphicsGetCurrentContext()
        {
            context.saveGState()
            
            // translate to the lower left corner
            context.translateBy(x: titleRect.minX, y: titleRect.maxY)
            context.rotate(by: -CGFloat.pi / 2.0)
            title.draw(at: CGPoint.zero, withAttributes: fontAttributes)
            
            context.restoreGState()
        }
    }
    
    fileprivate func drawOrdinatesAxisLegend_(_ rect: CGRect)
    {
        let horizontalSectionsCount = progressData_.horizontalSeparations.count
        guard horizontalSectionsCount > 0 else
        {
            return
        }
        
        let fontAttributes = legendFontAttributes_
        for (i, horizontalSeparation) in progressData_.horizontalSeparations.enumerated()
        {
            guard let legendTitle = horizontalSeparation.title else
            {
                continue
            }
            
            let legend = NSString(string: legendTitle)
            let legendSize = legend.size(withAttributes: fontAttributes)
            
            let separationIndex = horizontalSectionsCount - i - 1
            
            let y = rect.minY + rect.height / CGFloat(horizontalSectionsCount) * CGFloat(separationIndex)
            let legendPosition = CGPoint(x: rect.maxX - legendSize.width - legendRightPadding, y: y)
            
            legend.draw(at: legendPosition, withAttributes: fontAttributes)
        }
    }
    
    fileprivate func drawOrdinatesAxis_(forGridRect gridRect: CGRect)
    {
        let ordinatesAxisRect = CGRect(x: gridRect.minX - ordinatesAxisWidth, y: gridRect.minY, width: ordinatesAxisWidth, height: gridRect.height)
        ordinatesAxisColor.setFill()
        
        let ordinatesAxisPath = UIBezierPath(rect: ordinatesAxisRect)
        ordinatesAxisPath.fill()
    }
    
    fileprivate func drawHorizontalSeparations_(_ rect: CGRect, sectionHeight: CGFloat, count: Int, dashPattern: DashPattern)
    {
        guard count > 0 else
        {
            return
        }
        
        let horizontalSeparationsPath = UIBezierPath()
        horizontalSeparationsColor.setStroke()
        horizontalSeparationsPath.lineWidth = horizontalSeparationsWidth
        horizontalSeparationsPath.setLineDash(dashPattern.alternateLengths, count: dashPattern.alternateLengths.count, phase: dashPattern.phase)
        
        for i in 0..<count
        {
            let y = rect.minY + (rect.height - sectionHeight) / CGFloat(count) * CGFloat(i)
            horizontalSeparationsPath.move(to:    CGPoint(x: rect.minX, y: y))
            horizontalSeparationsPath.addLine(to: CGPoint(x: rect.maxX, y: y))
        }
        
        horizontalSeparationsPath.stroke()
    }
    
    fileprivate func drawAbscissaAxis_(forSectionsRect sectionsRect: CGRect)
    {
        let abscissaAxisRect = CGRect(x: sectionsRect.minX, y: sectionsRect.minY, width: sectionsRect.width, height: abscissaAxisHeight)
        let abscissaAxisPath = UIBezierPath(rect: abscissaAxisRect)
        abscissaAxisColor.setFill()
        abscissaAxisPath.fill()
    }
    
    fileprivate func drawSections_(forGridRect gridRect: CGRect, sectionHeight: CGFloat)
    {
        guard !progressData_.sections.isEmpty else
        {
            return
        }
        
        let sectionsPath = UIBezierPath()
        sectionLineColor.setStroke()
        sectionsPath.lineWidth = sectionLineWidth
        let dashPattern = progressData_.sectionDashPattern
        sectionsPath.setLineDash(dashPattern.alternateLengths, count: dashPattern.alternateLengths.count, phase: dashPattern.phase)
        
        let sectionsCount = progressData_.sections.count
        
        for i in 1..<sectionsCount
        {
            let x = CGFloat(i) / CGFloat(sectionsCount) * gridRect.width + gridRect.minX
            
            let startPoint = CGPoint(x: x, y: gridRect.minY)
            let endPoint = CGPoint(x: x, y: gridRect.maxY)
            
            sectionsPath.move(to: startPoint)
            sectionsPath.addLine(to: endPoint)
        }
        
        sectionsPath.stroke()
    }
    
    fileprivate func drawSubsections_(forGridRect gridRect: CGRect, sectionHeight: CGFloat)
    {
        guard !progressData_.sections.isEmpty && progressData_.subsections > 0 else
        {
            return
        }
        
        let dashPattern = progressData_.subsectionDashPattern
        let subsectionsPath = UIBezierPath()
        subsectionsPath.lineWidth = subsectionLineWidth
        subsectionsPath.setLineDash(dashPattern.alternateLengths, count: dashPattern.alternateLengths.count, phase: dashPattern.phase)
        subsectionLineColor.setStroke()
        
        let sectionsCount = progressData_.sections.count
        let sectionWidth = gridRect.width / CGFloat(sectionsCount)
        let maxY = gridRect.maxY - sectionHeight
        
        for sectionIndex in 0..<sectionsCount
        {
            for subsectionIndex in 0..<progressData_.subsections
            {
                let subsectionX = gridRect.minX + (CGFloat(sectionIndex) + CGFloat(subsectionIndex + 1) / CGFloat(progressData_.subsections + 1)) * sectionWidth
                
                let startPoint = CGPoint(x: subsectionX, y: gridRect.minY)
                let endPoint = CGPoint(x: subsectionX, y: maxY)
                
                subsectionsPath.move(to: startPoint)
                subsectionsPath.addLine(to: endPoint)
            }
        }
        
        subsectionsPath.stroke()
    }
    
    fileprivate func drawSectionTitles_(rect: CGRect)
    {
        let fontAttributes = sectionFontAttributes_
        
        for (i, section) in progressData_.sections.enumerated()
        {
            guard let sectionTitle = section.title else
            {
                continue
            }
            
            let x = rect.minX + CGFloat(i) / CGFloat(progressData_.sections.count) * rect.width + sectionTitleLeftPadding
            
            let title = NSString(string: sectionTitle)
            title.draw(at: CGPoint(x: x, y: rect.minY), withAttributes: fontAttributes)
        }
    }
    
    fileprivate func drawDiagram_(forGridRect gridRect: CGRect, sectionHeight: CGFloat)
    {
        let diagramRect = CGRect(x: gridRect.minX, y: gridRect.minY, width: gridRect.width, height: gridRect.height - sectionHeight)
        
        let scorePositions = scorePositions_(diagramRect: diagramRect)
        drawScorePoints_(scorePositions)
        drawIntegral_(diagramRect: diagramRect, positions: scorePositions)
    }
    
    fileprivate func scorePositions_(diagramRect: CGRect) -> [CGPoint]
    {
        var result = [CGPoint]()
        
        for scorePoint in progressData_.scores
        {
            let x = diagramRect.width * CGFloat(scorePoint.time / 100.0) + diagramRect.minX
            let y = diagramRect.height * CGFloat(scorePoint.score / 100.0) + diagramRect.minY
            
            result.append(CGPoint(x: x, y: y))
        }
        
        return result
    }
    
    fileprivate func drawScorePoints_(_ positions: [CGPoint])
    {
        guard let context = UIGraphicsGetCurrentContext() else
        {
            return
        }
        
        let scorePointPath = UIBezierPath(ovalIn: CGRect(x: -scorePointSize / 2.0, y: -scorePointSize / 2.0, width: scorePointSize, height: scorePointSize))
        scorePointPath.lineWidth = scorePointLineWidth
        scorePointColor.setStroke()
        
        var previousPoint = CGPoint.zero
        
        context.saveGState()
        for scorePosition in positions
        {
            context.translateBy(x: scorePosition.x - previousPoint.x, y: scorePosition.y - previousPoint.y)
            
            scorePointPath.stroke()
            
            previousPoint = scorePosition
        }
        context.restoreGState()
    }
    
    fileprivate func drawIntegral_(diagramRect: CGRect, positions: [CGPoint])
    {
        switch diagramType
        {
        case .fill:
            drawIntegralFilling_(diagramRect: diagramRect, positions: positions)
        case .line:
            drawIntegralStroking_(diagramRect: diagramRect, positions: positions)
        }
    }
    
    fileprivate func drawIntegralFilling_(diagramRect: CGRect, positions: [CGPoint])
    {
        let integralPath = integralPath_(positions: positions, diagramRect: diagramRect)
        
        guard let context = UIGraphicsGetCurrentContext() else
        {
            return
        }
        
        let startPoint = CGPoint(x: diagramRect.midX,   y: diagramRect.minY)
        let endPoint = CGPoint(x: diagramRect.midX,     y: diagramRect.maxY)
        
        context.saveGState()
        
        context.addPath(integralPath)
        context.clip(using: .winding)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace,
                                  colors: [diagramTopGradientColor.cgColor, diagramBottomGradientColor.cgColor] as CFArray,
                                  locations: [0.0, 1.0])!
        
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        context.drawPath(using: .fill)
        
        context.restoreGState()
    }
    
    fileprivate func drawIntegralStroking_(diagramRect: CGRect, positions: [CGPoint])
    {
        guard let first = positions.first else
        {
            return
        }
        
        let strokePath = UIBezierPath()
        strokePath.lineWidth = diagramStrokeWidth
        diagramStrokeColor.setStroke()
        
        var previousPoint = first
        for i in 1..<positions.count
        {
            let currentPoint = positions[i]
            let centersDeltaX = currentPoint.x - previousPoint.x
            let centersDeltaY = currentPoint.y - previousPoint.y
            
            if centersDeltaX == 0.0 && centersDeltaY == 0
            {
                continue
            }
            
            let length = sqrt(pow(centersDeltaX, 2) + pow(centersDeltaY,
                2))
            let ratio = scorePointSize / 2.0 / length
            
            let deltaX = centersDeltaX * ratio
            let deltaY = centersDeltaY * ratio
            
            let startPoint = CGPoint(x: previousPoint.x + deltaX, y: previousPoint.y + deltaY)
            let endPoint = CGPoint(x: currentPoint.x - deltaX, y: currentPoint.y - deltaY)
            
            strokePath.move(to: startPoint)
            strokePath.addLine(to: endPoint)
            
            previousPoint = currentPoint
        }
        
        strokePath.stroke()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - DIAGRAM PATH
    // -------------------------------------------------------------------------
    fileprivate func integralPath_(positions: [CGPoint], diagramRect: CGRect) -> CGPath
    {
        guard let first = positions.first,
            let last = positions.last else
        {
            return CGPath(rect: CGRect(), transform: nil)
        }
        let integralPath = UIBezierPath()
        integralPath.move(to: CGPoint(x: first.x, y: diagramRect.maxY))
        for position in positions
        {
            integralPath.addLine(to: position)
        }
        integralPath.addLine(to: CGPoint(x: last.x, y: diagramRect.maxY))
        return integralPath.cgPath
    }
}
