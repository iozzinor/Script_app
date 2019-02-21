//
//  WalkthroughPageViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 21/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class WalkthroughPageViewController: UIPageViewController
{
    static let contentViewControllerId = "WalkthroughContentViewControllerId"
    
    // -------------------------------------------------------------------------
    // MARK: - SECTIONS
    // -------------------------------------------------------------------------
    enum WalkthroughSection
    {
        case principle
        case types
        case example
        case scoringSystem
        case application
        
        var title: String {
            switch self
            {
            case .principle:
                return "Walkthrough.Section.Title.Principle".localized
            case .types:
                return "Walkthrough.Section.Title.Types".localized
            case .example:
                return "Walkthrough.Section.Title.Example".localized
            case .scoringSystem:
                return "Walkthrough.Section.Title.ScoringSystem".localized
            case .application:
                return "Walkthrough.Section.Title.Application".localized
            }
        }
        
        var description: String {
            switch self
            {
            case .principle:
                return "Walkthrough.Section.Description.Principle".localized
            case .types:
                return "Walkthrough.Section.Description.Types".localized
            case .example:
                return "Walkthrough.Section.Description.Example".localized
            case .scoringSystem:
                return "Walkthrough.Section.Description.ScoringSystem".localized
            case .application:
                return "Walkthrough.Section.Description.Application".localized
            }
        }
    }
    
    private let sections_: [WalkthroughSection] =
        [ .principle, .types, .example, .scoringSystem, .application]
    private var currentSection_ = 0
    
    private var sectionControllers_ = [WalkthroughContentViewController]()
    
    var sectionsCount: Int {
        return sections_.count
    }
    
    var sections: [WalkthroughSection] {
        return sections_
    }
    
    var currentSectionIndex: Int {
        get {
            return currentSection_
        }
    }
    
    var currentSection: WalkthroughSection {
        return sections_[currentSection_]
    }
    
    var walkthroughDelegate: WalkthroughPageViewControllerDelegate? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        
        loadContent()
        setupFirstContent()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - CONTENT VIEWS
    // -------------------------------------------------------------------------
    fileprivate func loadContent()
    {
        let storyboard = UIStoryboard(name: "Walkthrough", bundle: nil)
        
        for (i, section) in sections_.enumerated()
        {
            guard let newContentViewController
                = storyboard.instantiateViewController(withIdentifier:
                    WalkthroughPageViewController.contentViewControllerId)
                    as? WalkthroughContentViewController else
            {
                continue
            }
            
            setupContentSection(contentViewController: newContentViewController,
                                section: section)
            newContentViewController.view.tag = i
            sectionControllers_.append(newContentViewController)
        }
    }
    
    fileprivate func setupContentSection(
        contentViewController: WalkthroughContentViewController,
        section: WalkthroughSection)
    {
        contentViewController.sectionTitle = section.title
        contentViewController.sectionDescription = section.description
    }
    
    fileprivate func setupFirstContent()
    {
        guard let firstContent = sectionControllers_.first else
        {
            return
        }
        setViewControllers([firstContent], direction: .forward, animated: true,
                           completion: nil)
    }
}

// MARK: - UIPageViewControllerDelegate
extension WalkthroughPageViewController: UIPageViewControllerDelegate
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
            walkthroughDelegate?.walkthroughPageViewController(self,
                                       didTransistionToSectionAtIndex: newIndex)
        }
    }
}

// MARK: - UIPageViewControllerDataSource
extension WalkthroughPageViewController: UIPageViewControllerDataSource
{
    func pageViewController(
                            _ pageViewController: UIPageViewController,
                            viewControllerBefore viewController:
                                UIViewController)
        -> UIViewController?
    {
        if viewController.view.tag < 1
        {
            return nil
        }
        
        return sectionControllers_[viewController.view.tag - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController:
                                UIViewController)
        -> UIViewController?
    {
        if viewController.view.tag > sectionControllers_.count - 2
        {
            return nil
        }
        
        return sectionControllers_[viewController.view.tag + 1]
    }
}
