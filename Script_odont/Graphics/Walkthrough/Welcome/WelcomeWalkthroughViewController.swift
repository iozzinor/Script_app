//
//  WalkthroughViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 20/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class WelcomeWalkthroughViewController: UIViewController
{
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setup()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setup()
    {
        setupSkipButton()
    }
    
    fileprivate func setupSkipButton()
    {
        skipButton.layer.cornerRadius = skipButton.frame.height / 2
        skipButton.clipsToBounds = true
        skipButton.setTitle("WelcomeWalkthrough.SkipButton.Title.Skip".localized, for: .normal)
    }
    
    fileprivate func setup(welcomeWalkthroughPageViewController: WelcomeWalkthroughPageViewController)
    {
        setupPageControl(walkthroughPageViewController: welcomeWalkthroughPageViewController)
    }
    
    fileprivate func setupPageControl(walkthroughPageViewController: WelcomeWalkthroughPageViewController)
    {
        pageControl.numberOfPages = walkthroughPageViewController.sectionsCount
        pageControl.currentPage = walkthroughPageViewController.currentSectionIndex
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @IBAction func skip(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUES
    // -------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let walkthroughPageViewController = segue.destination
            as? WelcomeWalkthroughPageViewController
        {
            setup(welcomeWalkthroughPageViewController: walkthroughPageViewController)
            walkthroughPageViewController.welcomeWalkthroughDelegate = self
        }
    }
}

// -------------------------------------------------------------------------
// MARK: - WELCOME WALKTHROUGH PAGE VIEW CONTROLLER DELEGATE
// -------------------------------------------------------------------------
extension WelcomeWalkthroughViewController: WelcomeWalkthroughPageViewControllerDelegate
{
    func welcomeWalkthroughPageViewController(_ welcomeWalkthroughPageViewController: WelcomeWalkthroughPageViewController, didTransistionToSectionAtIndex sectionIndex: Int)
    {
        pageControl.currentPage = sectionIndex
        
        if sectionIndex == welcomeWalkthroughPageViewController.sectionsCount - 1
        {
            skipButton.setTitle("WelcomeWalkthrough.SkipButton.Title.Done".localized, for: .normal)
        }
        else
        {
            skipButton.setTitle("WelcomeWalkthrough.SkipButton.Title.Skip".localized, for: .normal)
        }
    }
}
