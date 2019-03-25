//
//  SwitchCell.swift
//  Script_odont
//
//  Created by Régis Iozzino on 25/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SwitchCell: UITableViewCell
{
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    {
        didSet
        {
            switchControl.addTarget(self, action: #selector(SwitchCell.switchDidUpdate_), for: .valueChanged)
        }
    }
    
    weak var delegate: SwitchCellDelegate? = nil
    
    @objc fileprivate func switchDidUpdate_(_ sender: UISwitch)
    {
        delegate?.switchCell(self, didSelectValue: sender.isOn)
    }
}
