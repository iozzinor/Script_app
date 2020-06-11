//
//  SctHorizontalQuestionHeaderCell.swift
//  Script_odont
//
//  Created by Régis Iozzino on 08/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

public class SctQuestionHeaderCell: UITableViewCell
{
    public struct Title
    {
        let hypothesis: String
        let newData: String
        let likertScale: String
        
        static let `default` = Title(hypothesis: "SctQuestionHeaderCell.Hypothesis".localized, newData: "SctQuestionHeaderCell.NewData".localized, likertScale: "SctQuestionHeaderCell.Impact".localized)
    }
    
    @IBOutlet weak var hypothesisLabel: UILabel! {
        didSet
        {
            hypothesisLabel.addBorders(with: Appearance.SctHorizontal.Table.borderColor, lineWidth: Appearance.SctHorizontal.Table.borderWidth, positions: [.left, .top])
        }
    }
    @IBOutlet weak var newDataLabel: UILabel! {
        didSet
        {
            newDataLabel.addBorders(with: Appearance.SctHorizontal.Table.borderColor, lineWidth: Appearance.SctHorizontal.Table.borderWidth, positions: [.left, .top])
        }
    }
    @IBOutlet weak var likertScaleLabel: UILabel! {
        didSet
        {
                likertScaleLabel.addBorders(with: Appearance.SctHorizontal.Table.borderColor, lineWidth: Appearance.SctHorizontal.Table.borderWidth, positions: [.left, .top, .right])
        }
    }
    
    func setTitle(_ title: Title)
    {
        hypothesisLabel.text = title.hypothesis
        newDataLabel.text = title.newData
        likertScaleLabel.text = title.likertScale
    }
}
