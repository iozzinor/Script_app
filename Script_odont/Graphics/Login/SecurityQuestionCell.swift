//
//  SigninSecurityQuestionCell.swift
//  Script_odont
//
//  Created by Régis Iozzino on 02/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SecurityQuestionCell: UITableViewCell
{
    @IBOutlet weak var questionIndex: UILabel!
    @IBOutlet weak var questionHeading: UILabel!
    @IBOutlet weak var answer: UITextField!
    
    func setup(for indexPath: IndexPath, securityQuestion: SecurityQuestion?)
    {
        questionIndex.text = "Question \(indexPath.row + 1)"
        if let question = securityQuestion
        {
            answer.isHidden = false
            answer.text = question.answer
            questionHeading.text = question.heading.content
        }
        else
        {
            answer.isHidden = true
            questionHeading.text = "SecurityQuestionPicker.Label.None".localized
        }
    }
}
