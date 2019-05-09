//
//  SctTypeWalkthroughViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 11/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SctTypeWalkthroughViewController: SctViewController
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    fileprivate var types_ = SctType.allCases
    fileprivate var currentType_ = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupTableView(tableView)
        
        dataSource = self
        
        pageControl.numberOfPages = types_.count
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SctTypeWalkthroughViewController.nextType_))
        view.addGestureRecognizer(tapGesture)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @IBAction func done(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectType(_ sender: UIPageControl)
    {
        currentType_ = pageControl.currentPage
        tableView.reloadData()
    }
    
    @objc fileprivate func nextType_(_ sender: UITapGestureRecognizer)
    {
        currentType_ += 1
        if currentType_ > types_.count - 1
        {
            currentType_ = 0
        }
        pageControl.currentPage = currentType_
        tableView.reloadData()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DATA SOURCE
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        switch section
        {
        case 1:
            return SctType.allCases[currentType_].name
        default:
            return nil
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - SCT VIEW DATA SOURCE
// -----------------------------------------------------------------------------
extension SctTypeWalkthroughViewController: SctViewDataSource
{
    var newDataDelegate: NewDataDelegate? {
        return nil
    }
    
    var sections: [SctViewController.SctSection] {
        return [.drawing, .information]
    }
    
    var currentSctQuestionIndex: Int {
        return 0
    }
    
    var currentSctQuestion: SctQuestion {
        var result = SctQuestion()
        result.items.append(SctItem())
        result.type = types_[currentType_]
        return result
    }
    
    var questionHeaderTitle: SctQuestionHeaderCell.Title? {
        return nil
    }
    
    var session: SctSession? {
        return nil
    }
    
    var canChooseLikertScale: Bool {
        return false
    }
    
    var shouldDisplaySingleQuestion: Bool { return false }
    
    var singleQuestionIndex: Int? { return nil }
    
    func sctItemCell(_ sctItemCell: SctItemCell, didSelectAnswer answer: LikertScale.Degree?)
    {
    }
    
    func sctItemCell(didSelectPreviousItem sctItemCell: SctItemCell)
    {
    }
    
    func sctItemCell(didSelectNextItem sctItemCell: SctItemCell)
    {
    }
}
