//
//  ScaHorizontalQuestionHeaderCell.swift
//  Script_odont
//
//  Created by Régis Iozzino on 08/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class ScaHorizontalQuestionHeaderCell: UITableViewCell
{
    @IBOutlet weak var hypothesisLabel: UILabel! {
        didSet
        {
            hypothesisLabel.addBorders(with: Appearance.ScaHorizontal.Table.borderColor, lineWidth: Appearance.ScaHorizontal.Table.borderWidth, positions: [.left, .top])
        }
    }
    @IBOutlet weak var newDataLabel: UILabel! {
        didSet
        {
            newDataLabel.addBorders(with: Appearance.ScaHorizontal.Table.borderColor, lineWidth: Appearance.ScaHorizontal.Table.borderWidth, positions: [.left, .top])
        }
    }
    @IBOutlet weak var likertScaleLabel: UILabel! {
        didSet
        {
                likertScaleLabel.addBorders(with: Appearance.ScaHorizontal.Table.borderColor, lineWidth: Appearance.ScaHorizontal.Table.borderWidth, positions: [.left, .top, .right])
        }
    }
}
