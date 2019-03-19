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
        var scores:                [Double]
        var minimumDisplayedScore: Double
        var maximumDisplayedScore: Double
        
        var ordinatesAxisTitle: String
        
        var horizontalSeparationDashPattern: DashPattern
        var sectionDashPattern: DashPattern
        var subsectionDashPattern: DashPattern
        
        init()
        {
            self.horizontalSeparations = []
            self.sections = []
            self.scores = []
            self.minimumDisplayedScore = ScoreProgressDiagram.defaultMinimumDisplayedScore_
            self.maximumDisplayedScore = ScoreProgressDiagram.defaultMaximumDisplayedScore_
            
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
    
    fileprivate static let defaultMinimumDisplayedScore_ = 0.0
    fileprivate static let defaultMaximumDisplayedScore_ = 100.0
    
    @IBInspectable var clearColor: UIColor = UIColor.white
    
    // ordinates title
    @IBInspectable var ordinatesAxisTitleColor: UIColor = UIColor.gray
    
    // horizontal separation
    @IBInspectable var horizontalSeparationsColor: UIColor = UIColor.gray
    @IBInspectable var horizontalSeparationsWidth: CGFloat = 0.2
    
    // section
    @IBInspectable var sectionLineColor: UIColor = UIColor.gray
    @IBInspectable var sectionLineWidth: CGFloat = 2.0
    
    // subsection
    @IBInspectable var subsectionLineColor: UIColor = UIColor.lightGray
    @IBInspectable var subsectionLineWidth: CGFloat = 1.0
    
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
    
    // -------------------------------------------------------------------------
    // MARK: - DATA
    // -------------------------------------------------------------------------
    func reloadData()
    {
        progressData_ = retrieveData_()
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
            result.minimumDisplayedScore = delegate.minimumDisplayedScore(for: self)
            result.maximumDisplayedScore = delegate.maximumDisplayedScore(for: self)
            
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
    
    fileprivate func ordinatesAxisLegendRect_(forOrdinatesAxisTitleRect ordinatesAxisTitleRect: CGRect, rect: CGRect) -> CGRect
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
        
        return CGRect(x: ordinatesAxisTitleRect.maxX + rect.minX, y: rect.minY, width: ordinatesAxisLegendWidth, height: rect.height)
    }
    
    fileprivate func gridRect_(forOrdinatesAxisLegendRect ordinatesAxisLegendRect: CGRect, rect: CGRect) -> CGRect
    {
        return CGRect(x: rect.minX + ordinatesAxisLegendRect.maxX, y: rect.minY, width: rect.width - ordinatesAxisLegendRect.maxX, height: rect.height)
    }
    
    fileprivate func sectionsRect_(forGridRect gridRect: CGRect) -> CGRect
    {
        let sectionsHeight: CGFloat
        if delegate != nil
        {
            sectionsHeight = delegate!.sectionHeight(for: self)
        }
        else
        {
            sectionsHeight = gridRect.height * ScoreProgressDiagram.defaultSectionsHeightRatio
        }
        return CGRect(x: gridRect.minX, y: gridRect.maxY - sectionsHeight, width: gridRect.width, height: sectionsHeight)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - DRAW
    // -------------------------------------------------------------------------
    override func draw(_ rect: CGRect)
    {
        let ordinatesAxisTitleRect = ordinatesAxisTitleRect_(bounds)
        let ordinatesAxisLegendRect = ordinatesAxisLegendRect_(forOrdinatesAxisTitleRect: ordinatesAxisTitleRect, rect: bounds)
        let gridRect = gridRect_(forOrdinatesAxisLegendRect: ordinatesAxisLegendRect, rect: bounds)
        let sectionsRect = sectionsRect_(forGridRect: gridRect)
        
        drawClear_(bounds)
        drawOrdinatesAxisTitle_(ordinatesAxisTitleRect)
        drawOrdinatesAxisLegend_(ordinatesAxisLegendRect)
        drawHorizontalSeparations_(gridRect,
                                   count: progressData_.horizontalSeparations.count,
                                   dashPattern: progressData_.horizontalSeparationDashPattern)
        drawSections_(rect: sectionsRect)
    }
    
    fileprivate func drawClear_(_ rect: CGRect)
    {
        clearColor.setFill()
        
        let clearPath = UIBezierPath(rect: rect)
        clearPath.fill()
    }
    
    fileprivate func drawOrdinatesAxisTitle_(_ rect: CGRect)
    {
        UIColor.red.setFill()
        
        let tempPath = UIBezierPath(rect: rect)
        tempPath.fill()
        
        let fontAttributes = ordinatesAxisTitleFontAttributes_
        
        let title = NSString(string: progressData_.ordinatesAxisTitle)
        let size = title.size(withAttributes: fontAttributes)
        
        let titleRect = CGRect(x: (rect.width - size.height) / 2 + rect.minX, y: rect.minY, width: size.height, height: size.width)
        let titlePath = UIBezierPath(rect: titleRect)
        UIColor.purple.setFill()
        titlePath.fill()
        
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
        UIColor.yellow.setFill()
        
        let tempPath = UIBezierPath(rect: rect)
        tempPath.fill()
    }
    
    fileprivate func drawHorizontalSeparations_(_ rect: CGRect, count: Int, dashPattern: DashPattern)
    {
        let horizontalSeparationsPath = UIBezierPath()
        horizontalSeparationsColor.setStroke()
        horizontalSeparationsPath.lineWidth = horizontalSeparationsWidth
        horizontalSeparationsPath.setLineDash(dashPattern.alternateLengths, count: dashPattern.alternateLengths.count, phase: dashPattern.phase)
        
        for i in 0..<count
        {
            let y = rect.minY + rect.height / CGFloat(count) * CGFloat(i)
            horizontalSeparationsPath.move(to:    CGPoint(x: rect.minX, y: y))
            horizontalSeparationsPath.addLine(to: CGPoint(x: rect.maxX, y: y))
        }
        
        horizontalSeparationsPath.stroke()
    }
    
    fileprivate func drawSections_(rect: CGRect)
    {
        UIColor.orange.setFill()
        let tempPath = UIBezierPath(rect: rect)
        tempPath.fill()
    }
}
