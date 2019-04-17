//
//  SctHorizontalQuestionCell.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit
import SceneKit

public class SctQuestionCell: UITableViewCell
{
    @IBOutlet weak var previousButton: UIButton!
    {
        didSet
        {
            previousButton.setImage(previousArrowImage_, for: .normal)
            previousButton.setImage(previousArrowImageDisabled_, for: .disabled)
        }
    }
    @IBOutlet weak var nextButton: UIButton!
        {
        didSet
        {
            nextButton.setImage(nextArrowImage_, for: .normal)
            nextButton.setImage(nextArrowImageDisabled_, for: .disabled)
        }
    }
    @IBOutlet weak var itemControl: UIPageControl!
    
    @IBOutlet weak var hypothesisLabel: UILabel! {
        didSet
        {
            hypothesisLabel.addBorders(with: Appearance.SctHorizontal.Table.borderColor, lineWidth: Appearance.SctHorizontal.Table.borderWidth, positions: [.left, .top])
        }
    }
    @IBOutlet weak var newDataView: NewDataView! {
        didSet
        {
            newDataView.addBorders(with: Appearance.SctHorizontal.Table.borderColor, lineWidth: Appearance.SctHorizontal.Table.borderWidth, positions: [.left, .top])
        }
    }
    @IBOutlet weak var scalesContainer: UIStackView! {
        didSet {
            clearScaleContainer_()
            setupScaleContainerButtons_()
            
            if scalesContainer.tag != 1
            {
                scalesContainer.tag = 1
                scalesContainer.addBorders(with: Appearance.SctHorizontal.Table.borderColor, lineWidth: Appearance.SctHorizontal.Table.borderWidth, positions: [.left, .top, .right])
            }
        }
    }
    
    var newDataLabel: UILabel? {
        return newDataView.label
    }
    
    fileprivate var scaleContainerButtons_ = [UIButton]()
    fileprivate var selectedScaleButton_: UIButton? = nil
    
    fileprivate var previousQuestionIndex_: Int = 0
    var currentQuestion: Int {
        get {
            return itemControl.currentPage
        }
        set {
            previousQuestionIndex_ = newValue
            itemControl.currentPage = newValue
            
            // enable
            previousButton.isEnabled = newValue > 0
            nextButton.isEnabled = newValue < itemsCount - 1
            
            rightSwipeGesture?.isEnabled =  newValue > 0
            leftSwipeGesture?.isEnabled = newValue < itemsCount - 1
        }
    }
    var itemsCount: Int = 0
    {
        didSet
        {
            itemControl.numberOfPages = itemsCount
        }
    }
    
    weak var delegate: SctQuestionCellDelegate? = nil
    
    var isLast = false
    {
        didSet
        {
            if isLast != oldValue
            {
                if isLast
                {
                    hypothesisLabel.addBorder(with: Appearance.SctHorizontal.Table.borderColor, lineWidth: Appearance.SctHorizontal.Table.borderWidth, position: .bottom)
                    newDataView.addBorder(with: Appearance.SctHorizontal.Table.borderColor, lineWidth: Appearance.SctHorizontal.Table.borderWidth, position: .bottom)
                    scalesContainer.addBorder(with: Appearance.SctHorizontal.Table.borderColor, lineWidth: Appearance.SctHorizontal.Table.borderWidth, position: .bottom)
                }
                else
                {
                    hypothesisLabel.removeBorders([.bottom])
                    newDataView.removeBorders([.bottom])
                    scalesContainer.removeBorders([.bottom])
                }
            }
        }
    }
    
    var canChooseLikertScale = true {
        didSet {
            guard canChooseLikertScale != oldValue else
            {
                return
            }
            
            for button in scaleContainerButtons_
            {
                if canChooseLikertScale
                {
                    button.addTarget(self, action: #selector(SctQuestionCell.selectedScaleButtonPressed_), for: .touchUpInside)
                }
                else
                {
                    button.removeTarget(self, action: #selector(SctQuestionCell.selectedScaleButtonPressed_), for: .touchUpInside)
                }
            }
        }
    }
    
    fileprivate var leftSwipeGesture: UISwipeGestureRecognizer? = nil
    fileprivate var rightSwipeGesture: UISwipeGestureRecognizer? = nil
    var displaySingleItem: Bool = false
    {
        didSet
        {
            previousButton.isHidden     = !displaySingleItem
            nextButton.isHidden         = !displaySingleItem
            itemControl.isHidden        = !displaySingleItem
            
            if displaySingleItem != oldValue
            {
                updateSwipeGestures_()
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
    
    fileprivate var previousArrowImage_: UIImage!
    fileprivate var previousArrowImageDisabled_: UIImage!
    fileprivate var nextArrowImage_: UIImage!
    fileprivate var nextArrowImageDisabled_: UIImage!
    
    // -------------------------------------------------------------------------
    // MARK: - INIT
    // -------------------------------------------------------------------------
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        let previousArrow = UIImage(named: "arrow_previous")!
        previousArrowImage_         = previousArrow.createImage(usingColor: UIColor.blue)
        previousArrowImageDisabled_ = previousArrow.createImage(usingColor: UIColor.gray)
        
        let nextArrow = UIImage(named: "arrow_next")!
        nextArrowImage_         = nextArrow.createImage(usingColor: UIColor.blue)
        nextArrowImageDisabled_ = nextArrow.createImage(usingColor: UIColor.gray)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
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
            newButton.addTarget(self, action: #selector(SctQuestionCell.selectedScaleButtonPressed_), for: .touchUpInside)
            
            scaleContainerButtons_.append(newButton)
            scalesContainer.addArrangedSubview(newButton)
        }
    }
    
    fileprivate func updateSwipeGestures_()
    {
        if displaySingleItem
        {
            leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(SctQuestionCell.swipeLeft_))
            leftSwipeGesture?.direction = .left
            leftSwipeGesture?.numberOfTouchesRequired = 1
            rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(SctQuestionCell.swipeRight_))
            rightSwipeGesture?.direction = .right
            rightSwipeGesture?.numberOfTouchesRequired = 1
            
            addGestureRecognizer(leftSwipeGesture!)
            addGestureRecognizer(rightSwipeGesture!)
        }
        else
        {
            if let leftSwipe = leftSwipeGesture, let rightSwipe = rightSwipeGesture
            {
                removeGestureRecognizer(leftSwipe)
                removeGestureRecognizer(rightSwipe)
            }
            
            leftSwipeGesture = nil
            rightSwipeGesture = nil
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @IBAction func selectPreviousQuestion(_ sender: UIButton)
    {
        previousQuestion_()
    }
    
    @IBAction func selectNextQuestion(_ sender: UIButton)
    {
       nextQuestion_()
    }
    
    fileprivate func previousQuestion_()
    {
        previousQuestionIndex_ -= 1
        delegate?.sctQuestionCell(didSelectPreviousQuestion: self)
    }
    
    fileprivate func nextQuestion_()
    {
        previousQuestionIndex_ += 1
        delegate?.sctQuestionCell(didSelectNextQuestion: self)
    }
    
    @IBAction func pageControlChanged(_ pageControl: UIPageControl)
    {
        if previousQuestionIndex_ < pageControl.currentPage
        {
            nextQuestion_()
        }
        else
        {
            previousQuestion_()
        }
    }
    
    @objc fileprivate func swipeLeft_(_ sender: UISwipeGestureRecognizer)
    {
        nextQuestion_()
    }
    
    @objc fileprivate func swipeRight_(_ sender: UISwipeGestureRecognizer)
    {
        previousQuestion_()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UPDATE DATA
    // -------------------------------------------------------------------------
    var item: SctItem = SctItem() {
        didSet {
            hypothesisLabel.text = item.hypothesis
            
            newDataView.questionData = item.newData
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
            
            delegate?.sctQuestionCell(self, didSelectAnswer: LikertScale.Degree(rawValue: selectedScale_))
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
