//
//  GoToSctCell.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class GoToSctCell: UITableViewCell
{
    @IBOutlet weak var sctNumberLabel: UILabel!
    @IBOutlet weak var sctWordingLabel: UILabel!
    @IBOutlet weak var sctStatus: GoToSctStatusView!
    
    func setSct(_ index: Int, wording: String, isValid: Bool)
    {
        sctNumberLabel.text = String.localizedStringWithFormat("GoToSct.SctIndex".localized, index + 1)
        sctWordingLabel.text = wording
        sctStatus.isValid = isValid
    }
}
