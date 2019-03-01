//
//  WalkthroughViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 20/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController
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
    }
    
    fileprivate func setup(walkthroughPageViewController: WalkthroughPageViewController)
    {
        setupPageControl(walkthroughPageViewController: walkthroughPageViewController)
    }
    
    fileprivate func setupPageControl(walkthroughPageViewController: WalkthroughPageViewController)
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
            as? WalkthroughPageViewController
        {
            setup(walkthroughPageViewController: walkthroughPageViewController)
            walkthroughPageViewController.walkthroughDelegate = self
        }
    }
}

// -------------------------------------------------------------------------
// MARK: - WalkthroughPageViewControllerDelegate
// -------------------------------------------------------------------------
extension WalkthroughViewController: WalkthroughPageViewControllerDelegate
{
    func walkthroughPageViewController(_ walkthroughPageViewController: WalkthroughPageViewController, didTransistionToSectionAtIndex sectionIndex: Int)
    {
        pageControl.currentPage = sectionIndex
        
        if sectionIndex == walkthroughPageViewController.sectionsCount - 1
        {
            skipButton.setTitle("Walkthrough.SkipButton.Title.Done".localized, for: .normal)
        }
        else
        {
            skipButton.setTitle("Walkthrough.SkipButton.Title.Skip".localized, for: .normal)
        }
    }
}
