//
//  SctScoreDiagramCell.swift
//  Script_odont
//
//  Created by Régis Iozzino on 15/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SctScoreDiagramCell: UITableViewCell
{
    @IBOutlet weak var scoreDiagram: SctScoreDiagram!
    
    var scoresDistribution: [Int] {
        get {
            return scoreDiagram.scoresDistribution
        }
        set {
            scoreDiagram.scoresDistribution = newValue
        }
    }
}
