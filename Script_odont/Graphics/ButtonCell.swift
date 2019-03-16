//
//  ButtonCell.swift
//  Script_odont
//
//  Created by Régis Iozzino on 16/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class ButtonCell: UITableViewCell
{
    @IBOutlet weak var buttonLabel: UILabel!
    
    func setTitle(_ title: String)
    {
        buttonLabel.text = title
        buttonLabel.prepareToDisplayRoundStyle()
        
        buttonLabel.textColor = UIColor.white
    }
}
