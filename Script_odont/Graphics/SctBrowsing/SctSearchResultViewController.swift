//
//  SctSearchResultViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 17/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

extension SctSearchCriterion
{
    fileprivate var explanation_: String {
        switch self
        {
        case let .topics(topics):
            return "\(topics.count)"
        case let .duration(minimum, maximum):
            return "\(Constants.durationString(forTimeInterval: minimum)) - \(Constants.durationString(forTimeInterval: maximum))"
        case let .questionsCount(minimum, maximum):
            return "\(minimum) - \(maximum)"
        case let .releaseDate(minimum, maximum):
            return "\(Constants.dateString(for: minimum)) - \(Constants.dateString(for: maximum))"
        }
    }
}

class SctSearchResultViewController: UITableViewController
{
    // -------------------------------------------------------------------------
    // MARK: - SEARCH RESULT SECTION
    // -------------------------------------------------------------------------
    fileprivate enum SearchResultSection
    {
        case summary
        case results
        
        var headerTitle: String?
        {
            switch self
            {
            case .summary:
                return "SctSearchResult.Section.Summary.Title".localized
            case .results:
                return "SctSearchResult.Section.Results.Title".localized
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEARCH RESULT ROW
    // -------------------------------------------------------------------------
    fileprivate enum SearchResultRow
    {
        case summaryCriterionExplanation(SctSearchCriterion)
        case allScts
        case noScts
        
        func cell(for indexPath: IndexPath, tableView: UITableView, sctSearchResultViewController: SctSearchResultViewController) -> UITableViewCell
        {
            switch self
            {
            case let .summaryCriterionExplanation(criterion):
                let cell = tableView.dequeueReusableCell(withIdentifier: SctSearchResultViewController.summaryCriterionCellId, for: indexPath)
                cell.textLabel?.text = criterion.name
                cell.detailTextLabel?.text = criterion.explanation_
                return cell
            case .allScts:
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.text = "SctSearchResult.AllScts".localized
                return cell
            case .noScts:
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.text = "SctSearchResult.NoScts".localized
                cell.textLabel?.textColor = Appearance.Color.missing
                return cell
            }
        }
        
        var accessroryType: UITableViewCell.AccessoryType {
            return .none
        }
        
        var selectionStyle: UITableViewCell.SelectionStyle {
            return .none
        }
    }
    
    static let summaryCriterionCellId = "SctSearchResultSummaryCriterionCellId"
    
    var criteria: [SctSearchCriterion]
    {
        get {
            return criteria_
        }
        set {
            criteria_ = newValue.sorted(by: { (left, right) -> Bool in
                return left.name < right.name
            })
        }
    }
    
    fileprivate var criteria_: [SctSearchCriterion] = []
    {
        didSet
        {
            if isViewLoaded
            {
                tableView.reloadData()
            }
        }
    }
    fileprivate var retrievedScts_ = [Sct]()
    fileprivate var sections_: [(section: SearchResultSection, rows: [SearchResultRow])]
    {
        var result = [(section: SearchResultSection, rows: [SearchResultRow])]()
        
        // all scts
        if criteria_.isEmpty
        {
            result.append((section: .summary, rows: [.allScts]))
        }
        // search summary
        else
        {
            var explanationRows = [SearchResultRow]()
            for criterion in criteria_
            {
                explanationRows.append(.summaryCriterionExplanation(criterion))
            }
            result.append((section: .summary, rows: explanationRows))
        }
        
        // not scts
        if retrievedScts_.isEmpty
        {
            result.append((section: .results, rows: [.noScts]))
        }
        
        return result
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @IBAction func cancel(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DELEGATE
    // -------------------------------------------------------------------------
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DATE SOURCE
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return sections_[section].section.headerTitle
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return sections_.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let rows = sections_[section].rows
        return rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let rows = sections_[indexPath.section].rows
        
        let row = rows[indexPath.row]
        
        let cell = row.cell(for: indexPath, tableView: tableView, sctSearchResultViewController: self)
        cell.accessoryType = row.accessroryType
        cell.selectionStyle = row.selectionStyle
        return cell
    }
}
