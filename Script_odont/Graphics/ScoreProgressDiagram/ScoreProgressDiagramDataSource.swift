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
    // vertical axis
    func numberOfHorizontalSeparations(in scoreProgressDiagram: ScoreProgressDiagram) -> Int
    func scoreProgressDiagram(_ scoreProgressDiagram: ScoreProgressDiagram, titleForHorizontalSeparation horizontalSeparationIndex: Int) -> String?
    func ordinatesAxisTitle(for scoreProgressDiagram: ScoreProgressDiagram) -> String
    
    // sections
    func numberOfSections(in scoreProgressDiagram: ScoreProgressDiagram) -> Int
    func scoreProgressDiagram(_ scoreProgressDiagram: ScoreProgressDiagram, titleForSection section: Int) -> String?
    
    // subsections
    func numberOfSubsections(in scoreProgressDiagram: ScoreProgressDiagram) -> Int
    
    // score
    func numberOfScores(for scoreProgressDiagram: ScoreProgressDiagram) -> Int
    func scoreProgressDiagram(_ scoreProgressDiagram: ScoreProgressDiagram, scoreForTime time: Int) -> ScoreProgressDiagram.ScorePoint
}
