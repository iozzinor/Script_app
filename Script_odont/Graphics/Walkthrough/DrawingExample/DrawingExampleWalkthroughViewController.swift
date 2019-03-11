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
    
    fileprivate var currentStep_ = Step.wording
    fileprivate var success_ = false
    fileprivate var successButton_: UIButton? = nil
    
    override public func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupTableView(tableView)
        
        dataSource = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawingExampleWalkthroughViewController.displayNextStep_))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc fileprivate func displayNextStep_(sender: UITapGestureRecognizer)
    {
        currentStep_ = currentStep_.next
        
        switch currentStep_
        {
        case .impact:
            view.removeGestureRecognizer(sender)
        case .hypothesis, .newData, .wording:
            break
        }
    }
    
    @IBAction func done(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let result = super.tableView(tableView, cellForRowAt: indexPath)
        
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
}

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
        sct.questions.append(SctQuestion(hypothesis: "WelcomeWalkthroughExample.Label.Description.Hypothesis".localized, newData: "WelcomeWalkthroughExample.Label.Description.Information".localized))
        
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
        guard !success_ else
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
    }
}
