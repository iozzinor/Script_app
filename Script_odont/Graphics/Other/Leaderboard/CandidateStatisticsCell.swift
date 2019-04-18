//
//  CandidateStatisticsCell.swift
//  Script_odont
//
//  Created by Régis Iozzino on 17/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class CandidateStatisticsCell: UITableViewCell
{
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var answeredSctExamsLabel: UILabel!
    @IBOutlet weak var meanScoreLabel: UILabel!
    
    func setStatistics(_ candidateStatistics: CandidateStatistics, displayUserName: Bool = true)
    {
        userNameLabel.isHidden = !displayUserName
        userNameLabel.text = candidateStatistics.name
        
        rankLabel.text = "\(candidateStatistics.rank)"
        
        answeredSctExamsLabel.text = "\(candidateStatistics.answeredScts)"
        
        meanScoreLabel.text = Constants.formatReal(candidateStatistics.meanScore)
    }
}
