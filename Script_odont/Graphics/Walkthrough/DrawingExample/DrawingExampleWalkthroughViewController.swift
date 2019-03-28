//
//  DrawingExampleWalkthroughViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 11/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

public class DrawingExampleWalkthroughViewController: SctViewController
{
    @IBOutlet weak var tableView: UITableView!
    
    // -------------------------------------------------------------------------
    // MARK: - STEP
    // -------------------------------------------------------------------------
    fileprivate enum Step: Int, CaseIterable
    {
        case wording
        case hypothesis
        case newData
        case impact
        
        var next: Step {
            let newRawValue = (rawValue < Step.allCases.count - 1 ? rawValue + 1 : 0)
            return Step(rawValue: newRawValue)!
        }
    }
    
    public let shouldDisplaySingleQuestion: Bool = false
    public let singleQuestionIndex: Int? = nil
    
    fileprivate var stepViews_ = [[UILabel]]()
    fileprivate var currentStep_ = Step.wording {
        didSet {
            updateStepUi_()
        }
    }
    fileprivate var success_ = false
    fileprivate var successButton_: UIButton? = nil
    fileprivate var overlayView_ = UIView()
    fileprivate var instructionLabel_ = UILabel()
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override public func viewDidLoad()
    {
        super.viewDidLoad()
        
        // initialize step views
        for _ in Step.allCases
        {
            stepViews_.append([])
        }
        setupTableView(tableView)
        
        dataSource = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawingExampleWalkthroughViewController.displayNextStep_))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        // register for device orientation
        NotificationCenter.default.addObserver(self, selector: #selector(DrawingExampleWalkthroughViewController.oriendationDidChange_), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    public override func viewWillAppear(_ animated: Bool)
    {
        updateStepUi_()
    }
    
    public override func viewWillDisappear(_ animated: Bool)
    {
        if overlayView_.superview != nil
        {
            overlayView_.removeFromSuperview()
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - DEVICE ORIENTATION
    // -------------------------------------------------------------------------
    @objc fileprivate func oriendationDidChange_(_ sender: Any)
    {
        updateOverlayFrame_()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - NEXT STEP
    // -------------------------------------------------------------------------
    @objc fileprivate func displayNextStep_(sender: UITapGestureRecognizer)
    {
        currentStep_ = currentStep_.next
        
        switch currentStep_
        {
        case .impact:
            view.removeGestureRecognizer(sender)
            displayOverlay_()
        case .hypothesis, .newData, .wording:
            break
        }
    }
    
    fileprivate func displayOverlay_()
    {
        var targetView = view!
        while targetView.superview != nil && targetView.superview!.window != nil
        {
            targetView = targetView.superview!
        }
        
        targetView.addSubview(overlayView_)
        overlayView_.frame = targetView.frame
        let likertFrame = getLikertFrame_()
        overlayView_.layer.mask = getOverlayMask_(for: overlayView_.frame, likertFrame: likertFrame)
        
        overlayView_.isUserInteractionEnabled = false
        overlayView_.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        instructionLabel_.text = "WelcomeWalkthroughExample.Label.Title.SelectImpact".localized
        instructionLabel_.textColor = UIColor.white
        instructionLabel_.sizeToFit()
        updateInstructionFrame_(likertFrame: likertFrame)
        
        overlayView_.addSubview(instructionLabel_)
    }
    
    fileprivate func getLikertFrame_() -> CGRect
    {
        guard let questionCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? SctQuestionCell else
        {
            return CGRect.zero
        }
        
        let likertPosition = view.convert(questionCell.scalesContainer.frame.origin, from: questionCell)
        let likertFrame = CGRect(origin: CGPoint(x: likertPosition.x + (questionCell.scalesContainer.superview?.frame.minX ?? 0), y: likertPosition.y), size: questionCell.scalesContainer.frame.size)
        return likertFrame
    }
    
    fileprivate func getOverlayMask_(for frame: CGRect, likertFrame: CGRect) -> CAShapeLayer
    {
        let result = CAShapeLayer()
        let path = CGMutablePath()
        
        path.addPath(CGPath(roundedRect: likertFrame, cornerWidth: 10, cornerHeight: 10, transform: nil))
        path.addPath(CGPath(rect: frame, transform: nil))
        result.fillColor = UIColor.white.cgColor
        result.backgroundColor = UIColor.clear.cgColor
        result.path = path
        result.fillRule = .evenOdd
        
        return result
    }
    
    fileprivate func updateOverlayFrame_()
    {
        overlayView_.frame.size = UIScreen.main.bounds.size
        overlayView_.isHidden = false
        let likertFrame = getLikertFrame_()
        overlayView_.layer.mask = getOverlayMask_(for: overlayView_.frame, likertFrame: likertFrame)
        updateInstructionFrame_(likertFrame: likertFrame)
    }
    
    fileprivate func updateInstructionFrame_(likertFrame: CGRect)
    {
        let x = (UIScreen.main.bounds.width - instructionLabel_.frame.width) / 2
        let y = (likertFrame.minY - instructionLabel_.frame.height) / 2
        instructionLabel_.frame.origin = CGPoint(x: x, y: y)
    }
    
    fileprivate func dismissOverlay_()
    {
        overlayView_.removeFromSuperview()
    }
    
    @IBAction func done(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func updateStepUi_()
    {
        for i in 0..<Step.allCases.count
        {
            for currentView in stepViews_[i]
            {
                let hidden = i > currentStep_.rawValue
                
                currentView.textColor = hidden ? UIColor.white : Appearance.Color.default
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DATA SOURCE
    // -------------------------------------------------------------------------
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let result = super.tableView(tableView, cellForRowAt: indexPath)
        
        if indexPath.section == 0
        {
            switch indexPath.row
            {
            case 0:
                stepViews_[0] = [(result as! SctWordingCell).wordingLabel]
            case 2:
                stepViews_[1] = [(result as! SctQuestionCell).hypothesisLabel]
                if let newDataLabel = (result as! SctQuestionCell).newDataLabel
                {
                    
                    stepViews_[2] = [newDataLabel]
                }
                stepViews_[3] = ((result as! SctQuestionCell).scalesContainer.arrangedSubviews as! [UIButton]).map { $0.titleLabel! }
            default:
                break
            }
        }
        else
        {
            updateStepUi_()
        }
        
        // update row color for success
        if success_ && indexPath.section == 1 && indexPath.row == (successButton_?.tag ?? -1)
        {
            if let cell = result as? SctScaleCell
            {
                cell.scaleCode.textColor = Appearance.Color.correct
                cell.scaleText.textColor = Appearance.Color.correct
            }
        }
        return result
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        if currentStep_ == .impact
        {
            overlayView_.isHidden = true
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if currentStep_ == .impact
        {
            updateOverlayFrame_()
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if currentStep_ == .impact
        {
            updateOverlayFrame_()
        }
    }
}

// -------------------------------------------------------------------------
// MARK: - SCT VIEW DATA SOURCE
// -------------------------------------------------------------------------
extension DrawingExampleWalkthroughViewController: SctViewDataSource
{
    public var sections: [SctViewController.SctSection] {
        return [.drawing, .information]
    }
    
    public var currentSctIndex: Int {
        return 0
    }
    
    public var currentSct: Sct {
        var sct = Sct()
        sct.topic = .diagnostic
        sct.wording = "WelcomeWalkthroughExample.Label.Description.Scenario".localized
        sct.questions.append(SctQuestion(hypothesis: "WelcomeWalkthroughExample.Label.Description.Hypothesis".localized, newData: SctData(text: "WelcomeWalkthroughExample.Label.Description.Information".localized)))
        
        return sct
    }
    
    public var questionHeaderTitle: SctQuestionHeaderCell.Title? {
        return nil
    }
    
    public var session: SctSession? {
        return nil
    }
    
    public var canChooseLikertScale: Bool {
        return true
    }
    
    public func sctQuestionCell(_ sctQuestionCell: SctQuestionCell, didSelectAnswer answer: LikertScale.Degree?)
    {
        guard let answer = answer else
        {
            successButton_?.isSelected = true
            return
        }
        let sender = sctQuestionCell.scalesContainer.arrangedSubviews[answer.rawValue] as! UIButton
        guard !success_, currentStep_ == .impact else
        {
            sender.isSelected = false
            successButton_?.isSelected = true
            return
        }
        
        if answer.rawValue < 3
        {
            incorrectAnswer_(sender)
        }
        else
        {
            correctAnswer_(sender)
        }
    }
    
    public func sctQuestionCell(_ sctQuestionCell: SctQuestionCell, didClickImageView imageView: UIImageView)
    {
    }
    
    public func sctQuestionCell(didSelectPreviousQuestion sctQuestionCell: SctQuestionCell)
    {
    }
    
    public func sctQuestionCell(didSelectNextQuestion sctQuestionCell: SctQuestionCell)
    {
    }
    
    fileprivate func incorrectAnswer_(_ sender: UIButton)
    {
        sender.transform = CGAffineTransform(translationX: 10, y: 0)
        sender.isSelected = false
        sender.setTitleColor(Appearance.Color.error, for: .normal)
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 4.0, options: [], animations: {
            sender.transform = CGAffineTransform.identity
        }, completion: {
            (_) -> Void in
            sender.setTitleColor(Appearance.Color.default, for: .normal)
        })
    }
    
    fileprivate func correctAnswer_(_ sender: UIButton)
    {
        success_ = true
        successButton_ = sender
        sender.tintColor = Appearance.Color.correct
        
        // update the row color
        tableView.reloadRows(at: [IndexPath(row: sender.tag, section: 1)], with: .automatic)
        
        dismissOverlay_()
    }
}
