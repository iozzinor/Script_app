//
//  SigninSecurityQuestionCell.swift
//  Script_odont
//
//  Created by Régis Iozzino on 02/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SigninSecurityQuestionCell: UITableViewCell
{
    @IBOutlet weak var questionIndex: UILabel!
    @IBOutlet weak var questionHeading: UILabel!
    @IBOutlet weak var answer: UITextField!
    
    func setup(for indexPath: IndexPath, securityQuestion: SecurityQuestion)
    {
        questionIndex.text = "Question \(indexPath.row + 1)"
        questionHeading.text = securityQuestion.heading.content
        answer.text = securityQuestion.answer
    }
}
