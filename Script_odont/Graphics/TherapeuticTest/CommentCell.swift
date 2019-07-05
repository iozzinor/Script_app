//
//  CommentCell.swift
//  Script_odont
//
//  Created by Régis Iozzino on 05/07/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell
{
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    func displayComment(_ comment: TctComment)
    {
        authorLabel.text = "\(comment.authorLastName.uppercased()) \(comment.authorFirstName)"
        dateLabel.text = Constants.dateString(for: comment.date)
        commentLabel.text = comment.text
    }
}
