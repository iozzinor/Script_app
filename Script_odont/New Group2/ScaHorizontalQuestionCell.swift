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
    @IBOutlet weak var hypothesisLabel: UILabel!
    @IBOutlet weak var newDataLabel: UILabel!
    @IBOutlet weak var scalesContainer: UIStackView! {
        didSet {
            clearScaleContainer_()
            setupScaleContainerButtons_()
        }
    }
    
    fileprivate var scaleContainerButtons_ = [UIButton]()
    fileprivate var selectedScaleButton_: UIButton? = nil
    
    weak var delegate: ScaHorizontalQuestionCellDelegate? = nil
    
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
        for (i, color) in Appearance.LikertScale.Color.all.enumerated()
        {
            let newButton = UIButton(type: .system)
            newButton.setTitle("\(i + 1)", for: .normal)
            newButton.setTitle("\(i + 1)", for: .selected)
            newButton.setTitleColor(color, for: .normal)
            
            newButton.tag = i
            newButton.tintColor = color
            
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
        if let answer = LikertScale.Degree(rawValue: sender.tag)
        {
            delegate?.scaHorizontalQuestionCell(self, didSelectAnswer: answer)
        }
    }
    
    func setAnswer(_ degree: LikertScale.Degree?)
    {
        selectedScale_ = degree?.rawValue ?? -1
    }
}
