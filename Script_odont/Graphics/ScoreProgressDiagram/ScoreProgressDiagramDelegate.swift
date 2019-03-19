//
//  ScoreProgressDiagramDelegate.swift
//  Script_odont
//
//  Created by Régis Iozzino on 18/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import CoreGraphics

protocol ScoreProgressDiagramDelegate: class
{
    // vertical axis
    func ordinatesAxisTitleWidth(for scoreProgressDiagram: ScoreProgressDiagram) -> CGFloat
    func ordinatesAxisLegendWidth(for scoreProgressDiagram: ScoreProgressDiagram) -> CGFloat
    func sectionHeight(for scoreProgressDiagram: ScoreProgressDiagram) -> CGFloat
    
    func horizontalSeparationDashPattern(for scoreProgressDiagram: ScoreProgressDiagram) -> DashPattern
    
    // section
    func sectionDashPattern(for scoreProgressDiagram: ScoreProgressDiagram) -> DashPattern
    
    // subsection
    func subsectionDashPattern(for scoreProgressDiagram: ScoreProgressDiagram) -> DashPattern
    
    // data
    func minimumDisplayedScore(for scoreProgressDiagram: ScoreProgressDiagram) -> Double
    func maximumDisplayedScore(for scoreProgressDiagram: ScoreProgressDiagram) -> Double
}

