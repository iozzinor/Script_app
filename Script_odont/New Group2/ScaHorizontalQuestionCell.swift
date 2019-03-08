//
//  ScaHorizontalQuestionCell.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

public class ScaHorizontalQuestionCell: UITableViewCell
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
    @IBOutlet weak var scalesContainer: UIStackView! {
        didSet {
            clearScaleContainer_()
            setupScaleContainerButtons_()
            
            if scalesContainer.tag != 1
            {
                scalesContainer.tag = 1
                scalesContainer.addBorders(with: Appearance.ScaHorizontal.Table.borderColor, lineWidth: Appearance.ScaHorizontal.Table.borderWidth, positions: [.left, .top, .right])
            }
        }
    }
    
    fileprivate var scaleContainerButtons_ = [UIButton]()
    fileprivate var selectedScaleButton_: UIButton? = nil
    
    weak var delegate: ScaHorizontalQuestionCellDelegate? = nil
    
    var isLast = false
    {
        didSet
        {
            if isLast
            {
                if hypothesisLabel.tag != 1
                {
                    hypothesisLabel.tag = 1
                    hypothesisLabel.addBorder(with: Appearance.ScaHorizontal.Table.borderColor, lineWidth: Appearance.ScaHorizontal.Table.borderWidth, position: .bottom)
                }
                if newDataLabel.tag != 1
                {
                    newDataLabel.tag = 1
                    newDataLabel.addBorder(with: Appearance.ScaHorizontal.Table.borderColor, lineWidth: Appearance.ScaHorizontal.Table.borderWidth, position: .bottom)
                }
                if (scalesContainer.tag >> 1) != 1
                {
                    scalesContainer.tag |= 2
                    scalesContainer.addBorder(with: Appearance.ScaHorizontal.Table.borderColor, lineWidth: Appearance.ScaHorizontal.Table.borderWidth, position: .bottom)
                }
            }
        }
    }
    
    fileprivate func clearScaleContainer_()
    {
        for arrangedSubview in scaleContainerButtons_
        {
            scalesContainer.removeArrangedSubview(arrangedSubview)
        }
        scaleContainerButtons_ = []
    }
    
    fileprivate func setupScaleContainerButtons_()
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
            newButton.isSelected = (i == selectedScale)
            if newButton.isSelected
            {
                selectedScaleButton_?.isSelected = false
                selectedScaleButton_ = newButton
            }
            
            // button target
            newButton.addTarget(self, action: #selector(ScaHorizontalQuestionCell.selectedScaleButtonPressed_), for: .touchUpInside)
            
            scaleContainerButtons_.append(newButton)
            scalesContainer.addArrangedSubview(newButton)
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UPDATE DATA
    // -------------------------------------------------------------------------
    var question: ScaQuestion = ScaQuestion() {
        didSet {
            hypothesisLabel.text = question.hypothesis
            newDataLabel.text = question.newData
        }
    }
    
    fileprivate var selectedScale_: Int = -1 {
        didSet {
            selectedScaleButton_?.isSelected = false
            if selectedScale_ < 0
            {
                selectedScaleButton_ = nil
            }
            else
            {
                selectedScaleButton_ = scaleContainerButtons_[selectedScale_]
            }
            
            selectedScaleButton_?.isSelected = true
            
            delegate?.scaHorizontalQuestionCell(self, didSelectAnswer: LikertScale.Degree(rawValue: selectedScale_))
        }
    }
    
    var selectedScale: Int {
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
    
    @objc fileprivate func selectedScaleButtonPressed_(_ sender: UIButton)
    {
        selectedScale = sender.tag
    }
    
    func setAnswer(_ degree: LikertScale.Degree?)
    {
        selectedScale_ = degree?.rawValue ?? -1
    }
}
