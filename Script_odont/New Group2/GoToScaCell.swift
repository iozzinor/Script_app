//
//  GoToScaCell.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class GoToScaCell: UITableViewCell
{
    @IBOutlet weak var scaNumberLabel: UILabel!
    @IBOutlet weak var scaWordingLabel: UILabel!
    @IBOutlet weak var scaStatus: GoToScaStatusView!
    
    func setSca(_ index: Int, wording: String, isValid: Bool)
    {
        scaNumberLabel.text = String.localizedStringWithFormat("GoToSca.ScaIndex".localized, index + 1)
        scaWordingLabel.text = wording
        scaStatus.isValid = isValid
    }
}
