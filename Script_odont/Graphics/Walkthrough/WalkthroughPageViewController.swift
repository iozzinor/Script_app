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
    // -------------------------------------------------------------------------
    // MARK: - PAGE VIEW DATA SOURCE
    // -------------------------------------------------------------------------
    fileprivate class SectionDataSource: NSObject, UIPageViewControllerDataSource
    {
        private var sections_: [WalkthroughSection]
        
        init(sections: [WalkthroughSection])
        {
            self.sections_ = sections
        }
        
        fileprivate lazy var sectionControllers_: [UIViewController] = ({
            var result = [UIViewController]()
            
            let storyboard = UIStoryboard(name: "Walkthrough", bundle: nil)
            
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
    enum WalkthroughSection
    {
        case abbreviation
        case principle
        case types
        case example
        case scoringSystem
        case application
        
        var title: String {
            switch self
            {
            case .abbreviation:
                return "Walkthrough.Section.Title.Abbreviation".localized
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
            case .abbreviation:
                return "Walkthrough.Section.Description.Abbreviation".localized
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
        
        func instantiateViewController(forStoryboard storyboard: UIStoryboard, identifier: Int) -> UIViewController
        {
            switch self
            {
            case .principle:
                let result = storyboard.instantiateViewController(withIdentifier: WalkthroughPrincipleViewController.storyboardId) as! WalkthroughPrincipleViewController
                result.view.tag = identifier
                return result
            case .types:
                let result = storyboard.instantiateViewController(withIdentifier: WalkthroughTypesViewController.storyboardId) as! WalkthroughTypesViewController
                result.view.tag = identifier
                return result
            default:
                break
            }
            
            let newContentViewController
                = storyboard.instantiateViewController(withIdentifier:
                    WalkthroughContentViewController.storyboardId)
                    as! WalkthroughContentViewController
            setupContentSection(contentViewController: newContentViewController)
            newContentViewController.view.tag = identifier
            
            return newContentViewController
        }
        
        fileprivate func setupContentSection(
            contentViewController: WalkthroughContentViewController)
        {
            contentViewController.sectionTitle = self.title
            contentViewController.sectionDescription = self.description
        }
    }
    
    private let sections_: [WalkthroughSection] =
        [ .abbreviation, .principle,
          .types, .example, .scoringSystem, .application]
    private var currentSection_ = 0
    
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
    
    weak var walkthroughDelegate: WalkthroughPageViewControllerDelegate? = nil
    
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
