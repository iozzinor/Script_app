//
//  WelcomeWalkthroughExampleViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 10/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class WelcomeWalkthroughExampleViewController: UIViewController
{
    // -------------------------------------------------------------------------
    // MARK: - STEP
    // -------------------------------------------------------------------------
    fileprivate enum ExampleStep: Int, CaseIterable
    {
        case wording
        case hypothesis
        case information
        case impact
        
        var next: ExampleStep
        {
            if rawValue < ExampleStep.allCases.count - 1
            {
                return ExampleStep(rawValue: rawValue + 1)!
            }
            return ExampleStep(rawValue: 0)!
        }
    }
    
    fileprivate static let paddingRatio_: CGFloat = 1.2
    
    @IBOutlet weak var scenarioTitleLabel: UILabel!
    @IBOutlet weak var scenarioDescriptionTextView: UITextView!
    @IBOutlet weak var hypothesisTitleLabel: UILabel!
    @IBOutlet weak var hypothesisDescriptionLabel: UILabel!
    @IBOutlet weak var informationTitleLabel: UILabel!
    @IBOutlet weak var informationDescriptionLabel: UILabel!
    @IBOutlet weak var impactTitleLabel: UILabel!
    
    @IBOutlet weak var containerView: UIStackView!
    
    fileprivate var currentStep_ = ExampleStep.wording
    {
        didSet
        {
            updateUi_()
            displayViews_(for: currentStep_)
        }
    }
    
    fileprivate var stepViews_ = [[UIView]]()
    fileprivate var impactButtons_ = [UIButton]()
    fileprivate var impactIncentiveView_ = UIView()
    fileprivate var tipLabel_ = UILabel()
    fileprivate var success_ = false
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setup_()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        currentStep_ = .wording
        success_ = false
        for button in impactButtons_
        {
            button.setTitleColor(nil, for: .normal)
            button.setTitleColor(nil, for: .selected)
        }
        
        // append the tap gesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WelcomeWalkthroughExampleViewController.nextStep))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        if impactIncentiveView_.superview != nil
        {
            impactIncentiveView_.removeFromSuperview()
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setup_()
    {
        setupLabels_()
        setupImpactButtons_()
        setupImpactIncentiveView_()
        setupTipLabel_()
        setupStepViews_()
    }
    
    fileprivate func setupLabels_()
    {
        scenarioTitleLabel.text = "WelcomeWalkthroughExample.Label.Title.Scenario".localized
        hypothesisTitleLabel.text = "WelcomeWalkthroughExample.Label.Title.Hypothesis".localized
        informationTitleLabel.text = "WelcomeWalkthroughExample.Label.Title.Information".localized
        impactTitleLabel.text = "WelcomeWalkthroughExample.Label.Title.Impact".localized
        
        scenarioDescriptionTextView.text = "WelcomeWalkthroughExample.Label.Description.Scenario".localized
        hypothesisDescriptionLabel.text = "WelcomeWalkthroughExample.Label.Description.Hypothesis".localized
        informationDescriptionLabel.text = "WelcomeWalkthroughExample.Label.Description.Information".localized
    }
    
    fileprivate func setupImpactButtons_()
    {
        let diagnosticScale = SctTopic.diagnostic.likertScale
        
        for code in -2...2
        {
            let scaleDescription = diagnosticScale[code]
            let impactTitle = String.localizedStringWithFormat("WelcomeWalkthroughExample.ImpactButton.Title".localized, code, scaleDescription)
            
            let impactButton = UIButton(type: .system)
            // title
            impactButton.setTitle(impactTitle, for: .normal)
            impactButton.setTitle(impactTitle, for: .selected)
            // tag
            impactButton.tag = code + 2
            // hide button by default
            impactButton.isHidden = true
            // line break
            impactButton.titleLabel?.numberOfLines = 0
            impactButton.titleLabel?.lineBreakMode = .byWordWrapping
            impactButton.titleLabel?.textAlignment = .justified
            impactButton.contentHorizontalAlignment = .left
            
            impactButtons_.append(impactButton)
            containerView.addArrangedSubview(impactButton)
            
            // left
            let leftConstraint = NSLayoutConstraint(item: impactButton, attribute: .left, relatedBy: .equal, toItem: scenarioTitleLabel, attribute: .left, multiplier: 1.0, constant: 0.0)
            containerView.addConstraint(leftConstraint)
            
            // actions
            if code < 1
            {
                impactButton.addTarget(self, action: #selector(WelcomeWalkthroughExampleViewController.incorrectAnswer), for: .touchUpInside)
            }
            else
            {
                impactButton.addTarget(self, action: #selector(WelcomeWalkthroughExampleViewController.correctAnswer), for: .touchUpInside)
            }
        }
    }
    
    fileprivate func setupImpactIncentiveView_()
    {
        impactIncentiveView_.translatesAutoresizingMaskIntoConstraints = false
        impactIncentiveView_.isHidden = true
        impactIncentiveView_.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        impactIncentiveView_.isUserInteractionEnabled = false
    }
    
    fileprivate func setupTipLabel_()
    {
        tipLabel_.text = "WelcomeWalkthroughExample.Label.Title.SelectImpact".localized
        tipLabel_.backgroundColor = UIColor.clear
        tipLabel_.textColor = UIColor.white
        tipLabel_.sizeToFit()
 
        tipLabel_.textAlignment = .center
        let newWidth = tipLabel_.frame.width * WelcomeWalkthroughExampleViewController.paddingRatio_
        let newHeight = tipLabel_.frame.height * WelcomeWalkthroughExampleViewController.paddingRatio_
        tipLabel_.frame = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
        
        impactIncentiveView_.addSubview(tipLabel_)
    }
    
    fileprivate func setupStepViews_()
    {
        // initialize step views
        stepViews_.append([scenarioTitleLabel, scenarioDescriptionTextView])
        stepViews_.append([hypothesisTitleLabel, hypothesisDescriptionLabel])
        stepViews_.append([informationTitleLabel, informationDescriptionLabel])
        stepViews_.append([impactTitleLabel])
        stepViews_[stepViews_.count - 1].append(contentsOf: impactButtons_)
        stepViews_[stepViews_.count - 1].append(impactIncentiveView_)
        stepViews_[stepViews_.count - 1].append(tipLabel_)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UPDATE UI
    // -------------------------------------------------------------------------
    fileprivate func updateUi_()
    {
        for (i, currentViews) in stepViews_.enumerated()
        {
            for currentView in currentViews
            {
                currentView.isHidden = i > currentStep_.rawValue
            }
        }
    }
    
    fileprivate func displayViews_(for step: ExampleStep)
    {
        let currentViews = stepViews_[step.rawValue]
        
        for currentView in currentViews
        {
            currentView.alpha = 0.0
        }
        
        UIView.animate(withDuration: 0.8, animations: {
            for currentView in currentViews
            {
                currentView.alpha = 1.0
            }
        })
    }
    
    fileprivate func displayImpactIncentives_()
    {
        // add the view to the hierarchy
        var targetView: UIView = view
        while targetView.superview != nil && targetView.superview?.window != nil
        {
            targetView = targetView.superview!
        }
        
        if impactIncentiveView_.superview != nil
        {
            impactIncentiveView_.removeFromSuperview()
        }
        impactIncentiveView_.frame = targetView.frame
        updateImpactIncentiveMask_(targetView: targetView)
        
        targetView.addSubview(impactIncentiveView_)
        targetView.bringSubviewToFront(impactIncentiveView_)
        
        // update tip position
        let x = (targetView.frame.width - tipLabel_.frame.width) / 2
        let y = (targetView.frame.height - tipLabel_.frame.height - targetView.convert(impactButtons_.first!.frame.origin, from: view).y) / 2
        tipLabel_.frame = CGRect(origin: CGPoint(x: x, y: y), size: tipLabel_.frame.size)
    }
    
    fileprivate func updateImpactIncentiveMask_(targetView: UIView)
    {
        let y = targetView.convert(impactButtons_.first!.frame.origin, from: view).y
        let width = (view.frame.width
            - 2 * impactButtons_.first!.frame.minX) + 10
        let height = view.frame.maxY - y
        
        // update the mask layer
        let maskLayer = CAShapeLayer()
        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.fillRule = .evenOdd
        
        let path = CGMutablePath()
        path.addPath(CGPath(roundedRect: CGRect(x: impactButtons_.first!.frame.minX - 5,
                                                y: y,
                                                width: width,
                                                height: height),
                            cornerWidth: 10,
                            cornerHeight: 10, transform: nil))
        path.addPath(CGPath(rect: UIScreen.main.bounds, transform: nil))
        maskLayer.path = path
        maskLayer.frame = UIScreen.main.bounds
        impactIncentiveView_.layer.mask = maskLayer
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UPDATE STEP
    // -------------------------------------------------------------------------
    @objc fileprivate func nextStep(_ tapGestureRecognizer: UITapGestureRecognizer)
    {
        switch currentStep_
        {
        case .impact:
            view.removeGestureRecognizer(tapGestureRecognizer)
            return
        case .wording, .hypothesis, .information:
            break
        }
        
        currentStep_ = currentStep_.next
        
        switch currentStep_
        {
        case .impact:
            displayImpactIncentives_()
        case .wording, .hypothesis, .information:
            break
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SELECT ANSWER
    // -------------------------------------------------------------------------
    @objc fileprivate func incorrectAnswer(_ sender: UIButton)
    {
        guard !success_ else
        {
            return
        }
        
        sender.transform = CGAffineTransform(translationX: 20, y: 0)
        
        let cachedColor = sender.titleColor(for: .normal) ?? UIColor.blue
        sender.setTitleColor(UIColor.red, for: .normal)
        sender.setTitleColor(UIColor.red, for: .selected)
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 4.0, options:  [.curveEaseOut], animations: {
            
            sender.transform = CGAffineTransform.identity
            
        }, completion: {
            (_: Bool) -> Void in
            
            sender.setTitleColor(cachedColor, for: .normal)
            sender.setTitleColor(cachedColor, for: .selected)
        })
    }
    
    @objc fileprivate func correctAnswer(_ sender: UIButton)
    {
        guard !success_ else
        {
            return
        }
        success_ = true
        
        let alertController = UIAlertController(title: "WelcomeWalkthroughExample.Success.Title".localized, message: "WelcomeWalkthroughExample.Success.Message".localized, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Common.Ok".localized, style: .default, handler: {
            (_) -> Void in
            
            sender.setTitleColor(UIColor.green, for: .normal)
            sender.setTitleColor(UIColor.green, for: .selected)
            
            self.impactIncentiveView_.removeFromSuperview()
        })
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
