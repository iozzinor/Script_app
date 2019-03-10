//
//  SctHorizontalSctleCell.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SctScaleCell: UITableViewCell
{
    @IBOutlet weak var scaleCode: UILabel!
    @IBOutlet weak var scaleText: UILabel!
    
    func setScale(code: Int, description: String)
    {
        scaleCode.text = "\(code):"
        scaleText.text = description
    }
}
