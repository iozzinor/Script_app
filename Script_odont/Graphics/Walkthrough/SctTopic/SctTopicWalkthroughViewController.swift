//
//  SctTopicWalkthroughViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 11/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SctTopicWalkthroughViewController: SctViewController
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    fileprivate var topics_ = SctTopic.allCases
    fileprivate var currentTopic_ = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupTableView(tableView)
        
        dataSource = self
        
        pageControl.numberOfPages = topics_.count
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SctTopicWalkthroughViewController.nextTopic_))
        view.addGestureRecognizer(tapGesture)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @IBAction func done(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectTopic(_ sender: UIPageControl)
    {
        currentTopic_ = pageControl.currentPage
        tableView.reloadData()
    }
    
    @objc func nextTopic_(_ sender: UITapGestureRecognizer)
    {
        currentTopic_ += 1
        if currentTopic_ > topics_.count - 1
        {
            currentTopic_ = 0
        }
        pageControl.currentPage = currentTopic_
        tableView.reloadData()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDataSource
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        switch section
        {
        case 1:
            return SctTopic.allCases[currentTopic_].name
        default:
            return nil
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - SCT VIEW DATA SOURCE
// -----------------------------------------------------------------------------
extension SctTopicWalkthroughViewController: SctViewDataSource
{
    var sections: [SctViewController.SctSection] {
        return [.drawing, .information]
    }
    
    var currentSctIndex: Int {
        return 0
    }
    
    var currentSct: Sct {
        var result = Sct()
        result.questions.append(SctQuestion())
        result.topic = topics_[currentTopic_]
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
    
    func sctQuestionCell(_ sctQuestionCell: SctQuestionCell, didSelectAnswer answer: LikertScale.Degree?)
    {
    }
    
    func sctQuestionCell(_ sctQuestionCell: SctQuestionCell, didClickImageView imageView: UIImageView)
    {
    }
    
    func sctQuestionCell(didSelectPreviousQuestion sctQuestionCell: SctQuestionCell)
    {
    }
    
    func sctQuestionCell(didSelectNextQuestion sctQuestionCell: SctQuestionCell)
    {
    }
}
