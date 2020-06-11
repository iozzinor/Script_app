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
            return "\(Constants.durationString(forTimeInterval: minimum * SctSearchViewController.maximumDuration)) - \(Constants.durationString(forTimeInterval: maximum * SctSearchViewController.maximumDuration))"
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
        case sct(SctLaunchInformation)
        
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
            case let .sct(launchInformation):
                let cell = tableView.dequeueReusableCell(for: indexPath) as SctBrowsingCell
                cell.setSctLaunchInformation(launchInformation)
                cell.informationLabel.text = ""
                return cell
            }
        }
        
        var accessroryType: UITableViewCell.AccessoryType {
            switch self
            {
            case .summaryCriterionExplanation(_), .allScts, .noScts:
                return .none
            case .sct(_):
                return .disclosureIndicator
            }
        }
        
        var selectionStyle: UITableViewCell.SelectionStyle {
            return .none
        }
    }
    
    static let toSctLaunch = "SctSearchResultToSctLaunchSegueId"
    
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
    fileprivate var pickedLaunchInformation_: SctLaunchInformation? = nil
    fileprivate var retrievedScts_: [SctLaunchInformation] = []
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
        else
        {
            result.append((section: .results, rows: retrievedScts_.map { .sct($0) }))
        }
        
        return result
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.registerNibCell(SctBrowsingCell.self)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUE
    // -------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == SctSearchResultViewController.toSctLaunch,
            let target = segue.destination as? SctLaunchViewController,
            let launchInformation = pickedLaunchInformation_
        {
            target.launchInformation = launchInformation
        }
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
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        let row = sections_[indexPath.section].rows[indexPath.row]
        
        switch row
        {
        case .sct(_):
            return indexPath
        case .summaryCriterionExplanation(_), .allScts, .noScts:
            return nil
        }
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let row = sections_[indexPath.section].rows[indexPath.row]
        
        switch row
        {
        case let .sct(launchInformation):
            pickedLaunchInformation_ = launchInformation
            performSegue(withIdentifier: SctSearchResultViewController.toSctLaunch, sender: self)
        case .summaryCriterionExplanation(_), .allScts, .noScts:
            break
        }
    }
    
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
