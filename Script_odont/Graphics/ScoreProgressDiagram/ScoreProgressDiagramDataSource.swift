//
//  ScoreProgressDiagramDataSource.swift
//  Script_odont
//
//  Created by Régis Iozzino on 18/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

protocol ScoreProgressDiagramDataSource: class
{
    // -------------------------------------------------------------------------
    // MARK: - VERTICAL AXIS
    // -------------------------------------------------------------------------
    /// - parameter scoreProgressDiagram: The score diagram.
    /// - returns: The number of horizontal lines to be drawn in the grid view.
    func numberOfHorizontalSeparations(in scoreProgressDiagram: ScoreProgressDiagram) -> Int
    
    /// - parameter scoreProgressDiagram: The score diagram.
    /// - parameter horizontalSeparationIndex: The index of the horizontal separation line.
    /// - returns: The title to be displayed for the horizontal separation line.
    
    func scoreProgressDiagram(_ scoreProgressDiagram: ScoreProgressDiagram, titleForHorizontalSeparation horizontalSeparationIndex: Int) -> String?
    /// - parameter scoreProgressDiagram: The score diagram.
    /// - returns: The title of the ordinates axis.
    func ordinatesAxisTitle(for scoreProgressDiagram: ScoreProgressDiagram) -> String
    
    // -------------------------------------------------------------------------
    // MARK: - SECTIONS
    // -------------------------------------------------------------------------
    /// Sections are separated with a vertical line.
    /// Its appearance might be controlled using the delegate (ScoreProgressDiagramDelegate).
    ///
    /// - parameter scoreProgressDiagram: The score diagram.
    /// - returns: The number of sections in the diagram.
    func numberOfSections(in scoreProgressDiagram: ScoreProgressDiagram) -> Int
    
    /// - parameter scoreProgressDiagram: The score diagram.
    /// - parameter section: The section index.
    /// - returns: The title for the section.
    func scoreProgressDiagram(_ scoreProgressDiagram: ScoreProgressDiagram, titleForSection section: Int) -> String?
    
    // -------------------------------------------------------------------------
    // MARK: - SUBSECTIONS
    // -------------------------------------------------------------------------
    /// - parameter scoreProgressDiagram: The score diagram.
    /// - returns: The number of subsection lines in the diagram.
    func numberOfSubsections(in scoreProgressDiagram: ScoreProgressDiagram) -> Int
    
    // -------------------------------------------------------------------------
    // MARK: - SCORE
    // -------------------------------------------------------------------------
    /// - parameter scoreProgressDiagram: The score diagram.
    /// - returns: The number of scores to be displayed in the diagram.
    func numberOfScores(for scoreProgressDiagram: ScoreProgressDiagram) -> Int
    
    /// The ScoreProgressDiagram view calls this method to obtain a specific score point.
    ///
    /// Points should be returned from older to newer.
    /// Their values should be normalized.
    ///
    /// - parameter scoreProgressDiagram: The score diagram.
    /// - parameter time: The index of the current score to be displayed.
    /// - returns: The score point.
    func scoreProgressDiagram(_ scoreProgressDiagram: ScoreProgressDiagram, scoreForTime time: Int) -> ScoreProgressDiagram.ScorePoint
}
