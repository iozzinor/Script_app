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
        
        func rows(for sctViewDataSource: SctViewDataSource?) -> [SctRow]
        {
            let question = sctViewDataSource?.currentSctQuestion ?? SctQuestion()
            switch self
            {
            case .drawing:
                var result: [SctRow] = [ .wording, .questionHeader ]
                
                if let dataSource = sctViewDataSource,
                    dataSource.shouldDisplaySingleQuestion
                {
                    result.append(SctRow.singleQuestion)
                }
                else
                {
                    result.append(contentsOf: Array<SctRow>(repeating: .item, count: question.items.count))
                }
                
                return result
            case .information:
                return Array<SctRow>(repeating: .scale, count: 5)
            }
        }
        
        var title: String? {
            switch self
            {
            case .drawing:
                return nil
            case .information:
                return nil
                //return "SctExam.Horizontal.Title.Information".localized
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
        case item
        case singleQuestion
        case scale
        
        func cell(for indexPath: IndexPath, tableView: UITableView, dataSource: SctViewDataSource?) -> UITableViewCell
        {
            let currentSctQuestion = dataSource?.currentSctQuestionIndex ?? 0
            
            let session = dataSource?.session
            let question = dataSource?.currentSctQuestion ?? SctQuestion()
            let singleQuestionIndex = dataSource?.singleQuestionIndex ?? 0
            
            switch self
            {
            case .wording:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SctWordingCell
                cell.wordingLabel.text = question.wording
                return cell
            case .questionHeader:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SctQuestionHeaderCell
                cell.setTitle(dataSource?.questionHeaderTitle ?? .default)
                return cell
            case .item:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SctItemCell
                cell.displaySingleItem = false
                cell.item = question.items[indexPath.row - 2]
                cell.tag = indexPath.row - 2
                cell.isLast = (indexPath.row - 1 == question.items.count)
                cell.canChooseLikertScale = dataSource?.canChooseLikertScale ?? false
                cell.delegate = dataSource
                cell.newDataView.delegate = dataSource?.newDataDelegate
                
                if let session = session
                {
                    // restore the answer
                    let answer = session[currentSctQuestion, indexPath.row - 2]
                    cell.setAnswer(answer)
                }
                return cell
                
            case .singleQuestion:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SctItemCell
                cell.displaySingleItem = true
                cell.item = question.items[singleQuestionIndex]
                cell.tag = singleQuestionIndex
                cell.isLast = true
                cell.canChooseLikertScale = dataSource?.canChooseLikertScale ?? false
                cell.delegate = dataSource
                cell.newDataView.delegate = dataSource?.newDataDelegate
                
                // question navigation
                cell.itemsCount = question.items.count
                cell.currentQuestion = singleQuestionIndex
                
                if let session = session
                {
                    // restore the answer
                    let answer = session[currentSctQuestion, singleQuestionIndex]
                    cell.setAnswer(answer)
                }
                return cell
                
            case .scale:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SctScaleCell
                
                let likertSctle = question.type.likertScale
                cell.setScale(code: indexPath.row - 2, description: likertSctle[indexPath.row - 2])
                return cell
            }
        }
        
        func preferredHeight(for indexPath: IndexPath, tableView: UITableView, dataSource: SctViewDataSource?) -> CGFloat
        {
            let question = dataSource?.currentSctQuestion ?? SctQuestion()
            switch self
            {
            case .questionHeader, .scale, .wording:
                return UITableView.automaticDimension
            case .item:
                
                switch question.items[indexPath.row - 2].newData.content
                {
                case .image(_):
                    return UIScreen.main.bounds.height / 3.0
                case .text(_), .volume(_):
                    return UITableView.automaticDimension
                }
            case .singleQuestion:
                return UIScreen.main.bounds.height / 2.0
            }
        }
    }
    
    weak var dataSource: SctViewDataSource? = nil
    
    fileprivate var sections_: [SctSection] {
        return dataSource?.sections ?? []
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
        tableView.registerNibCell(SctItemCell.self)
        tableView.registerNibCell(SctScaleCell.self)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - TABLE VIEW DELEGATE
    // -------------------------------------------------------------------------
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        return nil
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let section = sections_[indexPath.section]
        let rows = section.rows(for: dataSource)
        let row = rows[indexPath.row]
        return row.preferredHeight(for: indexPath, tableView: tableView, dataSource: dataSource)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - TABLE VIEW DATA SOURCE
    // -------------------------------------------------------------------------
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return sections_.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return sections_[section].title
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let section = sections_[section]
        return section.rows(for: dataSource).count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = sections_[indexPath.section]
        let rows = section.rows(for: dataSource)
        let row = rows[indexPath.row]
        
        let cell = row.cell(for: indexPath, tableView: tableView, dataSource: dataSource)
        cell.accessoryType      = .none
        cell.selectionStyle     = .none
        
        return cell
    }
}

