//
//  ScaHorizontalViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

public class ScaHorizontalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    // -------------------------------------------------------------------------
    // MARK: - SECTIONS
    // -------------------------------------------------------------------------
    private enum ScaSection: Int, CaseIterable
    {
        case drawing
        case information
        
        func rows(for sca: Sca) -> [ScaRow]
        {
            switch self
            {
            case .drawing:
                var result: [ScaRow] = [ .wording ]
                result.append(contentsOf: Array<ScaRow>(repeating: .question, count: sca.questions.count))
                
                return result
            case .information:
                return Array<ScaRow>(repeating: .scale, count: 5)
            }
        }
        
        func allRows(for sca: Sca) -> [ScaRow] {
            return ScaSection.allCases.flatMap { $0.rows(for: sca) }
        }
        
        var title: String? {
            switch self
            {
            case .drawing:
                return nil
            case .information:
                return "Information"
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ROWS
    // -------------------------------------------------------------------------
    private enum ScaRow
    {
        case wording
        case question
        case scale
        
        func cell(for indexPath: IndexPath, scaHorizontalViewController: ScaHorizontalViewController) -> UITableViewCell
        {
            let tableView = scaHorizontalViewController.tableView!
            let session = scaHorizontalViewController.scaSession
            let currentSca = scaHorizontalViewController.currentSca_
            
            let sca = session.exam.scas[currentSca]
            switch self
            {
            case .wording:
                let cell = tableView.dequeueReusableCell(for: indexPath) as ScaHorizontalWordingCell
                cell.wordingLabel.text = sca.wording
                return cell
            case .question:
                let cell = tableView.dequeueReusableCell(for: indexPath) as ScaHorizontalQuestionCell
                cell.question = sca.questions[indexPath.row - 1]
                cell.tag = indexPath.row - 1
                
                // restore the answer
                let answer = session[currentSca, indexPath.row - 1]
                cell.setAnswer(answer)
                cell.delegate = scaHorizontalViewController
                return cell
            case .scale:
                let cell = tableView.dequeueReusableCell(for: indexPath) as ScaHorizontalScaleCell
                
                let likertScale = sca.topic.likertScale
                cell.setScale(code: indexPath.row - 2, description: likertScale[indexPath.row - 2])
                return cell
            }
        }
    }
    
    @IBOutlet weak var progressItem: UIBarButtonItem!
    @IBOutlet weak var previousButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    public var scaSession = ScaSession(exam: ScaExam(scas: [])) {
        didSet {
            if isViewLoaded
            {
                updateUi_()
            }
        }
    }
    
    fileprivate var currentSca_ = 0 {
        didSet {
            if isViewLoaded
            {
                updateUi_()
            }
        }
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setup_()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setup_()
    {
        updateUi_()
        
        progressItem.isEnabled = false
        
        tableView.dataSource    = self
        tableView.delegate      = self
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UPDATE UI
    // -------------------------------------------------------------------------
    fileprivate func updateUi_()
    {
        updateProgress_()
        updateNavigationButtons_()
        tableView.reloadData()
    }
    
    fileprivate func updateProgress_()
    {
        progressItem.title = "Question \(currentSca_ + 1) out of \(scaSession.exam.scas.count)"
    }
    
    fileprivate func updateNavigationButtons_()
    {
        previousButton.isEnabled    = (currentSca_ > 0)
        nextButton.isEnabled        = (currentSca_ < scaSession.exam.scas.count - 1)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @IBAction func cancel(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func previous(_ sender: UIBarButtonItem)
    {
        guard currentSca_ > 0 else
        {
            return
        }
        
        currentSca_ -= 1
        
        updateNavigationButtons_()
    }
    
    @IBAction func next(_ sender: UIBarButtonItem)
    {
        guard currentSca_ < scaSession.exam.scas.count - 1 else
        {
            return
        }
        
        currentSca_ += 1
        
        updateNavigationButtons_()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - TABLE VIEW DELEGATE
    // -------------------------------------------------------------------------
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        return nil
    }
    
    // -------------------------------------------------------------------------
    // MARK: - TABLE VIEW DATA SOURCE
    // -------------------------------------------------------------------------
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return ScaSection.allCases.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return ScaSection.allCases[section].title
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let section = ScaSection.allCases[section]
        return section.rows(for: scaSession.exam.scas[currentSca_]).count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = ScaSection.allCases[indexPath.section]
        let rows = section.rows(for: scaSession.exam.scas[currentSca_])
        let row = rows[indexPath.row]
        
        let cell = row.cell(for: indexPath, scaHorizontalViewController: self)
        cell.accessoryType      = .none
        cell.selectionStyle     = .none
        return cell
    }
}

// -----------------------------------------------------------------------------
// MARK: - SCA HORIZONTAL QUESTION CELL DELEGATE
// -----------------------------------------------------------------------------
extension ScaHorizontalViewController: ScaHorizontalQuestionCellDelegate
{
    public func scaHorizontalQuestionCell(_ scaHorizontalQuestionCell: ScaHorizontalQuestionCell, didSelectAnswer answer: LikertScale.Degree?)
    {
        let questionIndex = scaHorizontalQuestionCell.tag
        scaSession[currentSca_, questionIndex] = answer
    }
}
