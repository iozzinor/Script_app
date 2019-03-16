//
//  SctSearchViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 15/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SctSearchViewController: UITableViewController
{
    // -------------------------------------------------------------------------
    // MARK: - SECTION
    // -------------------------------------------------------------------------
    fileprivate enum SearchSection
    {
        case criterion(SctSearchCriterion)
        case newCriterion
        case search
        
        var headerTitle: String?
        {
            switch self
            {
            case let .criterion(criterion):
                return criterion.name
            case .newCriterion, .search:
                return nil
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ROW
    // -------------------------------------------------------------------------
    fileprivate enum SearchRow
    {
        case criterion(SctSearchCriterion)
        
        case qualificationTopic(QualificationTopic)
        case pickQualificationTopics
        
        case addCriterion
        case performSearch
        
        func cell(for indexPath: IndexPath, tableView: UITableView, sctSearchViewController: SctSearchViewController) -> UITableViewCell
        {
            switch self
            {
            case let .criterion(criterion):
                let cell = tableView.dequeueReusableCell(withIdentifier: SctSearchViewController.criterionNameCellId, for: indexPath)
                cell.textLabel?.text = criterion.name
                return cell
                
            case let .qualificationTopic(topic):
                let cell = tableView.dequeueReusableCell(withIdentifier: SctSearchViewController.qualificationTopicCellId, for: indexPath)
                cell.textLabel?.text = topic.name
                return cell
            case .pickQualificationTopics:
                let cell = tableView.dequeueReusableCell(withIdentifier: SctSearchViewController.qualificationTopicCellId, for: indexPath)
                cell.textLabel?.text = "SctSearch.PickQualificationTopics.Title".localized
                return cell
                
            case .addCriterion:
                let cell = tableView.dequeueReusableCell(withIdentifier: SctSearchViewController.addCriterionCellId, for: indexPath)
                cell.textLabel?.textColor = Appearance.Color.action
                cell.textLabel?.text = "SctSearch.AddCriterion.Title".localized
                return cell
            case .performSearch:
                let cell = tableView.dequeueReusableCell(for: indexPath) as ButtonCell
                cell.setTitle("SctSearch.PerformSearch.Title".localized, enabled: sctSearchViewController.searchEnabled_)
                return cell
            }
        }
        
        func accessoryType(for indexPath: IndexPath, tableView: UITableView, sctSearchViewController: SctSearchViewController) -> UITableViewCell.AccessoryType
        {
            switch self
            {
            case .criterion(_), .qualificationTopic, .addCriterion, .performSearch:
                return .none
            case .pickQualificationTopics:
                return .disclosureIndicator
            }
        }
        
        func selectionStyle(for indexPath: IndexPath, tableView: UITableView, sctSearchViewController: SctSearchViewController) -> UITableViewCell.SelectionStyle
        {
            switch self
            {
            case .criterion(_), .qualificationTopic, .addCriterion, .performSearch:
                return .none
            case .pickQualificationTopics:
                return .none
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - STATIC PROPERTIES
    // -------------------------------------------------------------------------
    static let criterionNameCellId = "SctSearchCriterionNameCellReuseId"
    static let qualificationTopicCellId = "SctSearchQualificationTopicCellReuseId"
    static let addCriterionCellId = "SctSearchAddCriterionCellReuseId"
    
    static let toQualificationTopicsSegueId = "SctSearchToQualificationTopicsPickerSegueId"
    static let toSctSearchPickerSegueId = "SctSearchToSctSearchCriterionPickerSegueId"
    
    // -------------------------------------------------------------------------
    // MARK: - PROPERTIES
    // -------------------------------------------------------------------------
    fileprivate var criteria_ = [SctSearchCriterion]()
    fileprivate var sections_: [(section: SearchSection, rows: [SearchRow])] {
        var result = [(section: SearchSection, rows: [SearchRow])]()
        
        for criterion in criteria_
        {
            let rows = rowsForCriterion_(criterion)
            result.append((section: .criterion(criterion), rows: rows))
        }
        
        // add criterion
        if !SctSearchCriterion.pickableCriteria(alreadyPicked: criteria_).isEmpty
        {
            result.append((section: .newCriterion, rows: [.addCriterion]))
        }
        
        // search
        result.append((section: .search, rows: [.performSearch]))
        
        return result
    }
    fileprivate var currentIndexPath_: IndexPath? = nil
    
    fileprivate func rowsForCriterion_(_ searchCriterion: SctSearchCriterion) -> [SearchRow]
    {
        var result = [SearchRow.criterion(searchCriterion)]
        switch searchCriterion
        {
        case let .topics(topics):
            result.append(contentsOf: topics.map { .qualificationTopic($0) })
            result.append(.pickQualificationTopics)
        case .questionsCount(_, _):
            break
        case .releaseDate(_, _):
            break
        case let .duration(start, end):
            break
        }
        return result
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.registerNibCell(ButtonCell.self)
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
        
        criteria_.append(SctSearchCriterion.all.first!)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEARCH MANAGMENT
    // -------------------------------------------------------------------------
    fileprivate var searchEnabled_: Bool
    {
        return !criteria_.isEmpty
    }
    
    // -------------------------------------------------------------------------
    // MARK: - CRITERIA MANAGMENT
    // -------------------------------------------------------------------------
    fileprivate func removeCriterion_(indexPath: IndexPath)
    {
        let insertAddCriterion = SctSearchCriterion.pickableCriteria(alreadyPicked: criteria_).isEmpty
        criteria_.remove(at: indexPath.section)
        
        if insertAddCriterion
        {
            var sectionsToReload = [Int]()
            for i in 0..<(criteria_.count+1)
            {
                sectionsToReload.append(i)
            }
            tableView.reloadSections(IndexSet(sectionsToReload), with: .automatic)
        }
        else
        {
            tableView.deleteSections(IndexSet([indexPath.section]), with: .automatic)
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
    // MARK: - SEGUE
    // -------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // criterion picker
        if segue.identifier == SctSearchViewController.toSctSearchPickerSegueId,
            let target = (segue.destination as? UINavigationController)?.viewControllers.first as? SctSearchCriterionPickerViewController
        {
            target.delegate = self
            target.setPickedCriteria(criteria_)
        }
        // qualification topics
        if segue.identifier == SctSearchViewController.toQualificationTopicsSegueId,
            let target = segue.destination as? QualificationTopicsPickerViewController,
            currentIndexPath_ != nil
        {
            target.delegate = self
            
            switch criteria_[currentIndexPath_!.section]
            {
            case let .topics(topics):
                target.setPickedTopics(topics)
            default:
                break
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDelegate SELECTION
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        let row = sections_[indexPath.section].rows[indexPath.row]
        
        switch row
        {
        case .criterion(_), .qualificationTopic(_):
            return nil
        case .addCriterion, .pickQualificationTopics, .performSearch:
            return indexPath
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let row = sections_[indexPath.section].rows[indexPath.row]
        
        switch row
        {
        case .addCriterion:
            performSegue(withIdentifier: SctSearchViewController.toSctSearchPickerSegueId, sender: self)
        case .criterion(_), .qualificationTopic(_):
            break
        case .pickQualificationTopics:
            currentIndexPath_ = indexPath
            performSegue(withIdentifier: SctSearchViewController.toQualificationTopicsSegueId, sender: self)
        case .performSearch:
            break
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDelegate EDIT
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        let row = sections_[indexPath.section].rows[indexPath.row]
        
        switch row
        {
        case .addCriterion, .criterion(_):
            return true
        case .qualificationTopic(_), .pickQualificationTopics, .performSearch:
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    {
        let row = sections_[indexPath.section].rows[indexPath.row]
        
        switch row
        {
        case .addCriterion:
            return .insert
        case .criterion(_):
            return .delete
        case .qualificationTopic(_), .pickQualificationTopics, .performSearch:
            return .none
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        let row = sections_[indexPath.section].rows[indexPath.row]
        
        switch row
        {
        case .addCriterion:
            performSegue(withIdentifier: SctSearchViewController.toSctSearchPickerSegueId, sender: self)
        case .criterion(_):
            removeCriterion_(indexPath: indexPath)
        default:
            break
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDataSource
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
        return sections_[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let row = sections_[indexPath.section].rows[indexPath.row]
        
        let cell = row.cell(for: indexPath, tableView: tableView, sctSearchViewController: self)
        cell.accessoryType = row.accessoryType(for: indexPath, tableView: tableView, sctSearchViewController: self)
        cell.selectionStyle = row.selectionStyle(for: indexPath, tableView: tableView, sctSearchViewController: self)
        return cell
    }
}

// -----------------------------------------------------------------------------
// MARK: - SCT SEARCH CRITERION PICKER DELEGATE
// -----------------------------------------------------------------------------
extension SctSearchViewController: SctSearchCriterionPickerDelegate
{
    func sctSearchCriterionPicker(didCancelPick sctSearchCriterionPickerViewContorller: SctSearchCriterionPickerViewController)
    {
    }
    
    func sctSearchCriterionPicker(_ sctSearchCriterionPickerViewController: SctSearchCriterionPickerViewController, didPickCriterion pickedCriterion: SctSearchCriterion)
    {
        criteria_.append(pickedCriterion)
        
        if SctSearchCriterion.pickableCriteria(alreadyPicked: criteria_).isEmpty
        {
            tableView.reloadSections(IndexSet([criteria_.count - 1]), with: .automatic)
        }
        else
        {
            tableView.insertSections(IndexSet([criteria_.count - 1]), with: .automatic)
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - QUALIFICATION TOPICS PICKER DELEGATE
// -----------------------------------------------------------------------------
extension SctSearchViewController: QualificationTopicsPickerDelegate
{
    func qualificationTopicsPicker(_ qualificationTopicsPickerDelegateViewController: QualificationTopicsPickerViewController, didPickTopics pickedQualificationTopics: [QualificationTopic])
    {
        guard let criterionIndex = currentIndexPath_?.section else
        {
            return
        }
        criteria_[criterionIndex] = .topics(pickedQualificationTopics)
        
        tableView.reloadSections(IndexSet([criterionIndex]), with: .automatic)
        
        currentIndexPath_ = nil
    }
}
