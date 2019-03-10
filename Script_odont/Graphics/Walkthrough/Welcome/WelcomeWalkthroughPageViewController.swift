//
//  WalkthroughPageViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 21/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class WelcomeWalkthroughPageViewController: UIPageViewController
{
    // -------------------------------------------------------------------------
    // MARK: - PAGE VIEW DATA SOURCE
    // -------------------------------------------------------------------------
    fileprivate class SectionDataSource: NSObject, UIPageViewControllerDataSource
    {
        private var sections_: [WelcomeWalkthroughSection]
        
        init(sections: [WelcomeWalkthroughSection])
        {
            self.sections_ = sections
        }
        
        fileprivate lazy var sectionControllers_: [UIViewController] = ({
            var result = [UIViewController]()
            
            let storyboard = UIStoryboard(name: "WelcomeWalkthrough", bundle: nil)
            
            for (i, section) in sections_.enumerated()
            {
                let newContentViewController = section.instantiateViewController(forStoryboard: storyboard, identifier: i)
                
                result.append(newContentViewController)
            }
            return result
        }())
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
        {
            let sectionIndex = viewController.view.tag
            if sectionIndex < 1
            {
                return nil
            }
            
            return sectionControllers_[sectionIndex - 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
        {
            let sectionIndex = viewController.view.tag
            if sectionIndex > sectionControllers_.count - 2
            {
                return nil
            }
            
            return sectionControllers_[sectionIndex + 1]
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SECTIONS
    // -------------------------------------------------------------------------
    enum WelcomeWalkthroughSection
    {
        case welcome
        case sct
        case uncertainty
        
        var title: String {
            switch self
            {
            case .welcome:
                return ""
            case .sct:
                return "WelcomeWalkthrough.Section.Title.Sct".localized
            case .uncertainty:
                return "WelcomeWalkthrough.Section.Title.Uncertainty".localized
            }
        }
        
        var description: String {
            switch self
            {
            case .welcome:
                return "WelcomeWalkthrough.Section.Description.Welcome".localized
            case .sct:
                return "WelcomeWalkthrough.Section.Description.Sct".localized
            case .uncertainty:
                return "WelcomeWalkthrough.Section.Description.Uncertainty".localized
            }
        }
        
        func instantiateViewController(forStoryboard storyboard: UIStoryboard, identifier: Int) -> UIViewController
        {
            switch self
            {
            case .uncertainty:
                let viewController = storyboard.instantiateViewController(withIdentifier: WelcomeWalkthroughExampleViewController.storyboardId) as! WelcomeWalkthroughExampleViewController
                viewController.view.tag = identifier
                return viewController
            case .welcome, .sct:
                break
            }
            
            let newContentViewController
                = storyboard.instantiateViewController(withIdentifier:
                    WelcomeWalkthroughContentViewController.storyboardId)
                    as! WelcomeWalkthroughContentViewController
            setupContentSection(contentViewController: newContentViewController)
            newContentViewController.view.tag = identifier
            
            return newContentViewController
        }
        
        fileprivate func setupContentSection(
            contentViewController: WelcomeWalkthroughContentViewController)
        {
            contentViewController.sectionTitle = self.title
            contentViewController.sectionDescription = self.description
        }
    }
    
    private let sections_: [WelcomeWalkthroughSection] = [ .welcome, .sct, .uncertainty ]
    private var currentSection_ = 0
    
    var sectionsCount: Int {
        return sections_.count
    }
    
    var sections: [WelcomeWalkthroughSection] {
        return sections_
    }
    
    var currentSectionIndex: Int {
        get {
            return currentSection_
        }
    }
    
    var currentSection: WelcomeWalkthroughSection {
        return sections_[currentSection_]
    }
    
    weak var welcomeWalkthroughDelegate: WelcomeWalkthroughPageViewControllerDelegate? = nil
    
    fileprivate var sectionDataSource_: SectionDataSource? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.delegate = self
        self.sectionDataSource_ = SectionDataSource(sections: sections_)
        
        dataSource = sectionDataSource_
        
        displayFirstView()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - CONTENT VIEWS
    // -------------------------------------------------------------------------
    fileprivate func displayFirstView()
    {
        if let firstViewController = sectionDataSource_?.sectionControllers_.first
        {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
}

// MARK: - UIPageViewControllerDelegate
extension WelcomeWalkthroughPageViewController: UIPageViewControllerDelegate
{
    func pageViewController(_ pageViewController: UIPageViewController,
                            willTransitionTo pendingViewControllers:
                                [UIViewController])
    {
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool)
    {
        if let newIndex = pageViewController.viewControllers?.first?.view.tag
        {
            welcomeWalkthroughDelegate?.welcomeWalkthroughPageViewController(self,
                                       didTransistionToSectionAtIndex: newIndex)
        }
    }
}
