//
//  WalkthroughPrincipleDrawingCell.swift
//  Script_odont
//
//  Created by Régis Iozzino on 21/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class DrawingWalkthroughCell: UITableViewCell
{
    @IBOutlet weak var stackView: UIStackView!
    
    var labels: [UITextView] {
        return stackView.arrangedSubviews as! [UITextView]
    }
    
    var cellsCount: Int {
        get {
            return stackView.arrangedSubviews.count
        }
        set {
            if newValue == cellsCount
            {
                return
            }
            else if newValue > cellsCount
            {
                for _ in 0..<(newValue - cellsCount)
                {
                    let newLabel = UITextView()
                    newLabel.isEditable = false
                    newLabel.layer.borderWidth = 2
                    newLabel.layer.borderColor = UIColor.black.cgColor
                    newLabel.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                    
                    stackView.addArrangedSubview(newLabel)
                }
            }
            
            for _ in 0..<(cellsCount - newValue)
            {
                if let viewToRemove = stackView.arrangedSubviews.last
                {
                    stackView.removeArrangedSubview(viewToRemove)
                }
            }
        }
    }
}
