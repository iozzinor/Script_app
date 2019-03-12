//
//  SctPerformRateCell.swift
//  Script_odont
//
//  Created by Régis Iozzino on 12/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SctPerformRateCell: UITableViewCell
{
    static let cancellationDuration: TimeInterval = 4
    
    @IBOutlet weak var performRateButton: UIButton!
    @IBOutlet weak var starsContainer: UIStackView!
    
    fileprivate var stars_ = [RateStar]()
    fileprivate var selectedStar_ = -1
    fileprivate var isDisplayingStars_ = false
    
    fileprivate var cancellationTimer_: Timer? = nil
    
    @IBAction func displayStars(_ sender: UIButton)
    {
        if selectedStar_ < 0
        {
            prepareStars_()
        }
    }
    
    fileprivate func prepareStars_()
    {
        if stars_.isEmpty
        {
            for i in 0..<5
            {
                let newStar = RateStar()
                newStar.tag = i
                newStar.preventAnimation = true
                newStar.addTarget(self, action: #selector(SctPerformRateCell.starSelected_), for: .valueChanged)
                stars_.append(newStar)
                starsContainer.addArrangedSubview(newStar)
            }
        }
        
        isDisplayingStars_ = true
        // hide perform rate and display stars
        animateOut_(view: performRateButton, completion: {
            (_) -> Void in
            
            self.performRateButton.isHidden = true
            self.starsContainer.isHidden = false
            self.animateIn_(view: self.starsContainer)
        })
        
        // launch cancellation timer
        cancellationTimer_ = Timer.scheduledTimer(timeInterval: SctPerformRateCell.cancellationDuration, target: self, selector: #selector(SctPerformRateCell.cancellationTimerFired_), userInfo: nil, repeats: false)
    }
    
    @objc fileprivate func cancellationTimerFired_(_ sender: Timer)
    {
        invalidateCancellationTimer_()
        
        cancelVote()
    }
    
    fileprivate func invalidateCancellationTimer_()
    {
        cancellationTimer_?.invalidate()
        cancellationTimer_ = nil
    }
    
    func cancelVote()
    {
        if isDisplayingStars_
        {
            animateOut_(view: starsContainer, completion: {
                (_) -> Void in
                
                self.starsContainer.isHidden = true
                self.performRateButton.isHidden = false
                self.animateIn_(view: self.performRateButton)
            })
        }
        
        isDisplayingStars_ = false
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ANIMATIONS
    // -------------------------------------------------------------------------
    fileprivate func animateOut_(view: UIView, completion: ((Bool) -> Void)?)
    {
        view.transform = .identity
        view.alpha = 1.0
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseIn ], animations: {
            view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            view.alpha = 0.0
        }, completion: completion)
    }
    
    fileprivate func animateIn_(view: UIView)
    {
        view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        view.alpha = 0.0
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseOut ], animations: {
            view.transform = .identity
            view.alpha = 1.0
        }, completion: nil)
        
    }
    
    @objc fileprivate func starSelected_(_ sender: RateStar)
    {
        invalidateCancellationTimer_()
        
        let starIndex = sender.tag
        
        for (i, star) in stars_.enumerated()
        {
            let isSelected = (i <= starIndex)
            let animated: Bool
            if i != starIndex
            {
                animated = true
            }
            else
            {
                animated = selectedStar_ < starIndex
                star.setIsSelected(false, animated: false)
            }
            star.isEnabled = false
            star.setIsSelected(isSelected, animated: animated)
        }
        selectedStar_ = starIndex
    }
}
