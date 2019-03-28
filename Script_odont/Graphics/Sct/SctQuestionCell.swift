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
    @IBOutlet weak var questionControl: UIPageControl!
    
    @IBOutlet weak var hypothesisLabel: UILabel! {
        didSet
        {
            hypothesisLabel.addBorders(with: Appearance.SctHorizontal.Table.borderColor, lineWidth: Appearance.SctHorizontal.Table.borderWidth, positions: [.left, .top])
        }
    }
    @IBOutlet weak var newDataView: UIView! {
        didSet
        {
            setupDataView_()
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
        switch question.newData.content
        {
        case .text(_):
            return newDataLabel_
        case .image(_):
            return nil
        }
    }
    
    fileprivate var newDataViews_: [UIView] = []
    fileprivate var previousDataView_ = UIView()
    {
        didSet
        {
            oldValue.isHidden = true
            previousDataView_.isHidden = false
        }
    }
    fileprivate var newDataLabel_ = UILabel()
    fileprivate var newDataImageView_ = UIImageView()
    
    fileprivate var scaleContainerButtons_ = [UIButton]()
    fileprivate var selectedScaleButton_: UIButton? = nil
    
    fileprivate var previousQuestionIndex_: Int = 0
    var currentQuestion: Int {
        get {
            return questionControl.currentPage
        }
        set {
            previousQuestionIndex_ = newValue
            questionControl.currentPage = newValue
            
            // enable
            previousButton.isEnabled = newValue > 0
            nextButton.isEnabled = newValue < questionsCount - 1
            
            rightSwipeGesture?.isEnabled =  newValue > 0
            leftSwipeGesture?.isEnabled = newValue < questionsCount - 1
        }
    }
    var questionsCount: Int = 0
    {
        didSet
        {
            questionControl.numberOfPages = questionsCount
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
    var displaySingleQuestion: Bool = false
    {
        didSet
        {
            previousButton.isHidden     = !displaySingleQuestion
            nextButton.isHidden         = !displaySingleQuestion
            questionControl.isHidden    = !displaySingleQuestion
            
            if displaySingleQuestion != oldValue
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
    fileprivate func setupDataView_()
    {
        // clear
        for subview in newDataView.subviews
        {
            subview.removeFromSuperview()
        }
        newDataViews_.removeAll()
        
        // add subviews
        newDataViews_.append(newDataLabel_)
        newDataViews_.append(newDataImageView_)
        
        for newSubview in newDataViews_
        {
            newSubview.translatesAutoresizingMaskIntoConstraints = false
            newDataView.addSubview(newSubview)
            newSubview.isHidden = true
        }
        
        setupNewDataLabel_()
        setupNewDataImageView_()
    }
    
    fileprivate func setupNewDataLabel_()
    {
        newDataLabel_.numberOfLines = 0
        newDataLabel_.lineBreakMode = .byWordWrapping
        
        newDataView.adjustSubview(newDataLabel_)
        previousDataView_ = newDataLabel_
        newDataLabel_.isHidden = false
    }
    
    fileprivate func setupNewDataImageView_()
    {
        newDataView.adjustSubview(newDataImageView_)
        
        // touch listener
        let newDataImageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SctQuestionCell.imageViewTapped_))
        newDataImageGestureRecognizer.numberOfTapsRequired = 1
        newDataImageGestureRecognizer.numberOfTouchesRequired = 1
        newDataImageView_.gestureRecognizers?.removeAll()
        newDataImageView_.addGestureRecognizer(newDataImageGestureRecognizer)
        newDataImageView_.isUserInteractionEnabled = true
        newDataImageView_.contentMode = .scaleAspectFit
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
            newButton.addTarget(self, action: #selector(SctQuestionCell.selectedScaleButtonPressed_), for: .touchUpInside)
            
            scaleContainerButtons_.append(newButton)
            scalesContainer.addArrangedSubview(newButton)
        }
    }
    
    fileprivate func updateSwipeGestures_()
    {
        if displaySingleQuestion
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
    @objc fileprivate func imageViewTapped_(sender: UITapGestureRecognizer)
    {
        delegate?.sctQuestionCell(self, didClickImageView: newDataImageView_)
    }
    
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
    var question: SctQuestion = SctQuestion() {
        didSet {
            hypothesisLabel.text = question.hypothesis
            
            switch question.newData.content
            {
            case let .text(text):
                newDataLabel_.text = text
                newDataLabel_.sizeToFit()
                previousDataView_ = newDataLabel_
            case let .image(image):
                newDataImageView_.image = image
                previousDataView_ = newDataImageView_
            }
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
