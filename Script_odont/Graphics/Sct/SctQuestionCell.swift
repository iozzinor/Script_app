//
//  SctHorizontalQuestionCell.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

public class SctQuestionCell: UITableViewCell
{
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
    @IBOutlet weak var scalesContainer: UIStackView! {
        didSet {
            clearSctleContainer_()
            setupSctleContainerButtons_()
            
            if scalesContainer.tag != 1
            {
                scalesContainer.tag = 1
                scalesContainer.addBorders(with: Appearance.SctHorizontal.Table.borderColor, lineWidth: Appearance.SctHorizontal.Table.borderWidth, positions: [.left, .top, .right])
            }
        }
    }
    
    fileprivate var scaleContainerButtons_ = [UIButton]()
    fileprivate var selectedSctleButton_: UIButton? = nil
    
    weak var delegate: SctQuestionCellDelegate? = nil
    
    var isLast = false
    {
        didSet
        {
            if isLast
            {
                if hypothesisLabel.tag != 1
                {
                    hypothesisLabel.tag = 1
                    hypothesisLabel.addBorder(with: Appearance.SctHorizontal.Table.borderColor, lineWidth: Appearance.SctHorizontal.Table.borderWidth, position: .bottom)
                }
                if newDataLabel.tag != 1
                {
                    newDataLabel.tag = 1
                    newDataLabel.addBorder(with: Appearance.SctHorizontal.Table.borderColor, lineWidth: Appearance.SctHorizontal.Table.borderWidth, position: .bottom)
                }
                if (scalesContainer.tag >> 1) != 1
                {
                    scalesContainer.tag |= 2
                    scalesContainer.addBorder(with: Appearance.SctHorizontal.Table.borderColor, lineWidth: Appearance.SctHorizontal.Table.borderWidth, position: .bottom)
                }
            }
        }
    }
    
    fileprivate func clearSctleContainer_()
    {
        for arrangedSubview in scaleContainerButtons_
        {
            scalesContainer.removeArrangedSubview(arrangedSubview)
        }
        scaleContainerButtons_ = []
    }
    
    fileprivate func setupSctleContainerButtons_()
    {
        for i in 0..<5
        {
            let newButton = UIButton(type: .system)
            newButton.setTitle("\(i - 2)", for: .normal)
            newButton.setTitle("\(i - 2)", for: .selected)
            newButton.setTitleColor(Appearance.LikertScale.Color.default, for: .normal)
            
            newButton.tag = i
            newButton.tintColor = Appearance.LikertScale.Color.selected
            
            // select the currently selected answer button
            newButton.isSelected = (i == selectedSctle)
            if newButton.isSelected
            {
                selectedSctleButton_?.isSelected = false
                selectedSctleButton_ = newButton
            }
            
            // button target
            newButton.addTarget(self, action: #selector(SctQuestionCell.selectedSctleButtonPressed_), for: .touchUpInside)
            
            scaleContainerButtons_.append(newButton)
            scalesContainer.addArrangedSubview(newButton)
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UPDATE DATA
    // -------------------------------------------------------------------------
    var question: SctQuestion = SctQuestion() {
        didSet {
            hypothesisLabel.text = question.hypothesis
            newDataLabel.text = question.newData
        }
    }
    
    fileprivate var selectedScale_: Int = -1 {
        didSet {
            selectedSctleButton_?.isSelected = false
            if selectedScale_ < 0
            {
                selectedSctleButton_ = nil
            }
            else
            {
                selectedSctleButton_ = scaleContainerButtons_[selectedScale_]
            }
            
            selectedSctleButton_?.isSelected = true
            
            delegate?.sctQuestionCell(self, didSelectAnswer: LikertScale.Degree(rawValue: selectedScale_))
        }
    }
    
    var selectedSctle: Int {
        set {
            
            if newValue == selectedScale_
            {
                selectedScale_ = -1
            }
            else
            {
                selectedScale_ = newValue
            }
         
        }
        get {
            return selectedScale_
        }
    }
    
    @objc fileprivate func selectedSctleButtonPressed_(_ sender: UIButton)
    {
        selectedSctle = sender.tag
    }
    
    func setAnswer(_ degree: LikertScale.Degree?)
    {
        selectedScale_ = degree?.rawValue ?? -1
    }
}
