//
//  TherapeuticChoiceCell.swift
//  Script_odont
//
//  Created by Régis Iozzino on 14/05/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class TherapeuticChoiceCell: UITableViewCell
{
    @IBOutlet weak var therapeuticLabel: UILabel!
    @IBOutlet weak var scaleContainer: UIStackView!
    
    fileprivate var rowIndex_ = -1
    fileprivate var scaleButtons_ = [UIButton]()
    fileprivate var selectedIndex_ = -1
    
    var delegate: TherapeuticChoiceDelegate? = nil
    
    fileprivate func clearScaleButtons_()
    {
        for button in scaleButtons_
        {
            scaleContainer.removeArrangedSubview(button)
        }
        
        scaleButtons_.removeAll()
    }
    
    func displayScales(scaleValues: [Int], selected: Int, rowIndex: Int)
    {
        self.rowIndex_ = rowIndex
        if scaleButtons_.count != scaleValues.count
        {
            clearScaleButtons_()
            
            for (i, value) in scaleValues.enumerated()
            {
                let newButton = UIButton(type: .system)
                newButton.setTitle("\(value)", for: .normal)
                newButton.setTitle("\(value)", for: .selected)
                newButton.setTitleColor(Appearance.LikertScale.Color.default, for: .normal)
                
                newButton.tag = i
                newButton.tintColor = Appearance.LikertScale.Color.selected
                
                newButton.addTarget(self, action: #selector(TherapeuticChoiceCell.scaleSelected_), for: .touchUpInside)
                
                scaleContainer.addArrangedSubview(newButton)
                scaleButtons_.append(newButton)
            }
        }
        
        for button in scaleButtons_
        {
            button.isSelected = false
        }
        if selected > -1
        {
            selectedIndex_ = selected
            scaleButtons_[selected].isSelected = true
        }
    }
    
    @objc fileprivate func scaleSelected_(_ button: UIButton)
    {
        let newSelection = button.tag
        if newSelection == selectedIndex_
        {
            button.isSelected = false
            selectedIndex_ = -1
        }
        else
        {
            if selectedIndex_ > -1
            {
                scaleButtons_[selectedIndex_].isSelected = false
            }
            scaleButtons_[newSelection].isSelected = true
            selectedIndex_ = newSelection
        }
        delegate?.didSelectValue(at: selectedIndex_, for: rowIndex_)
    }
}
