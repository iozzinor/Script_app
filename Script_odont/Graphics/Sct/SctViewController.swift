//
//  SctViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 10/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

public class SctViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    // -------------------------------------------------------------------------
    // MARK: - SECTIONS
    // -------------------------------------------------------------------------
    public enum SctSection: Int, CaseIterable
    {
        case drawing
        case information
        
        func rows(for sct: Sct) -> [SctRow]
        {
            switch self
            {
            case .drawing:
                var result: [SctRow] = [ .wording, .questionHeader ]
                result.append(contentsOf: Array<SctRow>(repeating: .question, count: sct.questions.count))
                
                return result
            case .information:
                return Array<SctRow>(repeating: .scale, count: 5)
            }
        }
        
        func allRows(for sct: Sct) -> [SctRow] {
            return SctSection.allCases.flatMap { $0.rows(for: sct) }
        }
        
        var title: String? {
            switch self
            {
            case .drawing:
                return nil
            case .information:
                return "SctExam.Horizontal.Title.Information".localized
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ROWS
    // -------------------------------------------------------------------------
    enum SctRow
    {
        case wording
        case questionHeader
        case question
        case scale
        
        func cell(for indexPath: IndexPath, tableView: UITableView, dataSource: SctViewDataSource?) -> UITableViewCell
        {
            let currentSct = dataSource?.currentSctIndex ?? 0
            
            let session = dataSource?.session ?? SctSession(exam: SctExam())
            let sct = dataSource?.currentSct ?? Sct()
            switch self
            {
            case .wording:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SctWordingCell
                cell.wordingLabel.text = sct.wording
                return cell
            case .questionHeader:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SctQuestionHeaderCell
                cell.hypothesisLabel.text   = "SctExam.Horizontal.Headers.Hypothesis".localized
                cell.newDataLabel.text      = "SctExam.Horizontal.Headers.NewData".localized
                cell.likertScaleLabel.text  = "SctExam.Horizontal.Headers.Impact".localized
                return cell
            case .question:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SctQuestionCell
                cell.question = sct.questions[indexPath.row - 2]
                cell.tag = indexPath.row - 2
                cell.isLast = (indexPath.row - 1 == sct.questions.count)
                
                // restore the answer
                let answer = session[currentSct, indexPath.row - 2]
                cell.setAnswer(answer)
                cell.delegate = dataSource
                return cell
            case .scale:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SctScaleCell
                
                let likertSctle = sct.topic.likertScale
                cell.setScale(code: indexPath.row - 2, description: likertSctle[indexPath.row - 2])
                return cell
            }
        }
    }
    
    var dataSource: SctViewDataSource? = nil
    
    var sections: [SctSection] {
        return dataSource?.sections ?? []
    }
    var currentSct: Sct {
        return dataSource?.currentSct ?? Sct()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    func setupTableView(_ tableView: UITableView)
    {
        tableView.dataSource    = self
        tableView.delegate      = self
        
        tableView.registerNibCell(SctWordingCell.self)
        tableView.registerNibCell(SctQuestionHeaderCell.self)
        tableView.registerNibCell(SctQuestionCell.self)
        tableView.registerNibCell(SctScaleCell.self)
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
        return SctSection.allCases.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return SctSection.allCases[section].title
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let section = sections[section]
        return section.rows(for: currentSct).count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = sections[indexPath.section]
        let rows = section.rows(for: currentSct)
        let row = rows[indexPath.row]
        
        let cell = row.cell(for: indexPath, tableView: tableView, dataSource: dataSource)
        cell.accessoryType      = .none
        cell.selectionStyle     = .none
        return cell
    }
}

