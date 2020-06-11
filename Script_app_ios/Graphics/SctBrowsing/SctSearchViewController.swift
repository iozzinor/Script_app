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
        
        case minimumReleaseDate(Date)
        case maximumReleaseDate(Date)
        
        case minimumQuestionsCount(Int)
        case maximumQuestionsCount(Int)
        
        case minimumDurationPicker(Double)
        case maximumDurationPicker(Double)
        
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
                
            case let .minimumReleaseDate(minimumDate):
                let cell = tableView.dequeueReusableCell(withIdentifier: SctSearchViewController.releaseDateCellId, for: indexPath)
                cell.textLabel?.text = "SctSearch.DurationPicker.Minimum.Date".localized
                cell.detailTextLabel?.text = Constants.dateString(for: minimumDate)
                return cell
            case let .maximumReleaseDate(maximumDate):
                let cell = tableView.dequeueReusableCell(withIdentifier: SctSearchViewController.releaseDateCellId, for: indexPath)
                cell.textLabel?.text = "SctSearch.DurationPicker.Maximum.Date".localized
                cell.detailTextLabel?.text = Constants.dateString(for: maximumDate)
                return cell
                
            case let .minimumQuestionsCount(minimumQuestions):
                sctSearchViewController.questionsCountCriterionIndex_ = indexPath.section
                let cell = tableView.dequeueReusableCell(for: indexPath) as QuestionsCountCell
                cell.questionsCountLabel.text = "SctSearch.DurationPicker.Minimum.QuestionsCount".localized
                cell.questionsCountTextField.text = "\(minimumQuestions)"
                cell.questionsCountTextField.delegate = sctSearchViewController
                cell.questionsCountTextField.tag = SctSearchViewController.minimumTag_
                sctSearchViewController.minimumQuestionsTextField_ = cell.questionsCountTextField
                return cell
            case let .maximumQuestionsCount(maximumQuestions):
                sctSearchViewController.questionsCountCriterionIndex_ = indexPath.section
                let cell = tableView.dequeueReusableCell(for: indexPath) as QuestionsCountCell
                cell.questionsCountLabel.text = "SctSearch.DurationPicker.Maximum.QuestionsCount".localized
                cell.questionsCountTextField.text = "\(maximumQuestions)"
                cell.questionsCountTextField.delegate = sctSearchViewController
                cell.questionsCountTextField.tag = SctSearchViewController.maximumTag_
                sctSearchViewController.maximumQuestionsTextField_ = cell.questionsCountTextField
                return cell
                
            case let .minimumDurationPicker(minimumDuration):
                sctSearchViewController.durationCriterionIndex_ = indexPath.section
                let cell = tableView.dequeueReusableCell(for: indexPath) as DurationPickerCell
                sctSearchViewController.minimumDurationCell_ = cell
                
                cell.slider.tag = SctSearchViewController.minimumTag_
                cell.slider.addTarget(self, action: #selector(SctSearchViewController.updateDuration_), for: .valueChanged)
                cell.durationLabel.text = "SctSearch.DurationPicker.Minimum".localized
                cell.slider.value = Float(minimumDuration / SctSearchViewController.maximumDuration)
                cell.valueLabel.text = Constants.durationString(forTimeInterval: minimumDuration)
                return cell
            case let .maximumDurationPicker(maximumDuration):
                sctSearchViewController.durationCriterionIndex_ = indexPath.section
                let cell = tableView.dequeueReusableCell(for: indexPath) as DurationPickerCell
                sctSearchViewController.maximumDurationCell_ = cell
                
                cell.slider.tag = SctSearchViewController.maximumTag_
                cell.slider.addTarget(self, action: #selector(SctSearchViewController.updateDuration_), for: .valueChanged)
                cell.durationLabel.text = "SctSearch.DurationPicker.Maximum".localized
                cell.slider.value = Float(maximumDuration / SctSearchViewController.maximumDuration)
                cell.valueLabel.text = Constants.durationString(forTimeInterval: TimeInterval(maximumDuration))
                return cell
                
            case .addCriterion:
                let cell = tableView.dequeueReusableCell(withIdentifier: SctSearchViewController.addCriterionCellId, for: indexPath)
                cell.textLabel?.textColor = Appearance.Color.action
                cell.textLabel?.text = "SctSearch.AddCriterion.Title".localized
                return cell
            case .performSearch:
                let cell = tableView.dequeueReusableCell(for: indexPath) as ButtonCell
                cell.setTitle("SctSearch.PerformSearch.Title".localized)
                return cell
            }
        }
        
        func accessoryType(for indexPath: IndexPath, tableView: UITableView, sctSearchViewController: SctSearchViewController) -> UITableViewCell.AccessoryType
        {
            switch self
            {
            case .criterion(_), .qualificationTopic, .addCriterion,
                 .minimumQuestionsCount(_), .maximumQuestionsCount(_),
                 .minimumDurationPicker(_), .maximumDurationPicker(_), .performSearch:
                return .none
            case .pickQualificationTopics,
                .minimumReleaseDate(_), .maximumReleaseDate(_):
                return .disclosureIndicator
            }
        }
        
        func selectionStyle(for indexPath: IndexPath, tableView: UITableView, sctSearchViewController: SctSearchViewController) -> UITableViewCell.SelectionStyle
        {
            return .none
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - STATIC PROPERTIES
    // -------------------------------------------------------------------------
    static let criterionNameCellId      = "SctSearchCriterionNameCellReuseId"
    static let qualificationTopicCellId = "SctSearchQualificationTopicCellReuseId"
    static let addCriterionCellId       = "SctSearchAddCriterionCellReuseId"
    static let releaseDateCellId        = "SctSearchReleaseDateCellReuseId"
    
    static let toQualificationTopics = "SctSearchToQualificationTopicsPickerSegueId"
    static let toSctSearchPicker     = "SctSearchToSctSearchCriterionPickerSegueId"
    static let toDatePicker          = "SctSearchToDatePickerSegueId"
    static let toSctSearchResult     = "SctSearchToSctSearchResultSeguId"
    
    /// The maximum SCT duration in seconds.
    static let maximumDuration = 7200.0
    
    fileprivate static let minimumTag_ = 0
    fileprivate static let maximumTag_ = 1
    
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
    
    fileprivate var pickMinimumDate_ = false
    fileprivate var minimumDate_ = Date(timeIntervalSinceNow: -7 * 24 * 3600.0)
    fileprivate var maximumDate_ = Date()
    
    fileprivate var questionsCountCriterionIndex_ = 0
    fileprivate var updateMinimumQuestionsCount_ = false
    fileprivate var minimumQuestionsCount_ = 0
    fileprivate var maximumQuestionsCount_ = Sct.maximumTotalItemsCount
    fileprivate var minimumQuestionsTextField_: UITextField? = nil
    fileprivate var maximumQuestionsTextField_: UITextField? = nil
    
    fileprivate var durationCriterionIndex_ = 0
    fileprivate var minimumDuration_ = 0.0
    fileprivate var maximumDuration_ = 1.0
    fileprivate var minimumDurationCell_: DurationPickerCell? = nil
    fileprivate var maximumDurationCell_: DurationPickerCell? = nil
    
    fileprivate func rowsForCriterion_(_ searchCriterion: SctSearchCriterion) -> [SearchRow]
    {
        var result = [SearchRow.criterion(searchCriterion)]
        switch searchCriterion
        {
        case let .topics(topics):
            result.append(contentsOf: topics.map { .qualificationTopic($0) })
            result.append(.pickQualificationTopics)
        case let .questionsCount(minimumQuestions, maximumQuestions):
            result.append(.minimumQuestionsCount(minimumQuestions))
            result.append(.maximumQuestionsCount(maximumQuestions))
        case let .releaseDate(minimumDate, maximumDate):
            result.append(.minimumReleaseDate(minimumDate))
            result.append(.maximumReleaseDate(maximumDate))
        case let .duration(start, end):
            result.append(.minimumDurationPicker(start))
            result.append(.maximumDurationPicker(end))
        }
        return result
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.registerNibCell(ButtonCell.self)
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
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
    
    @objc fileprivate func updateDuration_(_ sender: UISlider)
    {
        let newString = Constants.durationString(forTimeInterval: Double(sender.value) * SctSearchViewController.maximumDuration)
        // minimum
        if sender.tag == SctSearchViewController.minimumTag_
        {
            // can not be greater than maximumDuration_
            if sender.value > Float(maximumDuration_)
            {
                maximumDuration_ = Double(sender.value)
                maximumDurationCell_?.slider.value = Float(maximumDuration_)
                maximumDurationCell_?.valueLabel.text = newString
            }
            minimumDuration_ = Double(sender.value)
            minimumDurationCell_?.valueLabel.text = newString
        }
        else
        {
            var value = sender.value
            if sender.value < Float(minimumDuration_)
            {
                value = Float(minimumDuration_)
                maximumDurationCell_?.slider.value = value
            }
            maximumDuration_ = Double(value)
            maximumDurationCell_?.valueLabel.text = Constants.durationString(forTimeInterval: Double(value) * SctSearchViewController.maximumDuration)
        }
        
        // update criteria
        criteria_[durationCriterionIndex_] = .duration(minimumDuration_,
                                                       maximumDuration_)
    }
    
    fileprivate func checkSearchAll_()
    {
        let searchAllAlert = UIAlertController(title: "SctSearch.SearchAllAlert.Title".localized, message: "SctSearch.SearchAllAlert.Message".localized, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Common.Yes".localized, style: .default, handler: {
            (_) -> Void in
            self.performSegue(withIdentifier: SctSearchViewController.toSctSearchResult, sender: self)
        })
        let noAction = UIAlertAction(title: "Common.No".localized, style: .cancel, handler: nil)
        
        searchAllAlert.addAction(noAction)
        searchAllAlert.addAction(yesAction)
        
        present(searchAllAlert, animated: true, completion: nil)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUE
    // -------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // criterion picker
        if segue.identifier == SctSearchViewController.toSctSearchPicker,
            let target = (segue.destination as? UINavigationController)?.viewControllers.first as? SctSearchCriterionPickerViewController
        {
            target.delegate = self
            target.setPickedCriteria(criteria_)
        }
        // qualification topics
        if segue.identifier == SctSearchViewController.toQualificationTopics,
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
        // date picker
        else if segue.identifier == SctSearchViewController.toDatePicker,
            let target = segue.destination as? DatePickerViewController
        {
            target.delegate = self
            
            if pickMinimumDate_
            {
                target.maximumDate = maximumDate_
                target.date = minimumDate_
            }
            else
            {
                target.minimumDate = minimumDate_
                target.date = maximumDate_
                target.maximumDate = Date()
            }
        }
        // search result
        else if segue.identifier == SctSearchViewController.toSctSearchResult,
            let target = (segue.destination as? UINavigationController)?.viewControllers.first as? SctSearchResultViewController
        {
            target.criteria = criteria_
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DELEGATE SELECTION
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        let row = sections_[indexPath.section].rows[indexPath.row]
        
        switch row
        {
        case .criterion(_), .qualificationTopic(_),
             .minimumQuestionsCount(_), .maximumQuestionsCount(_),
             .minimumDurationPicker, .maximumDurationPicker:
            return nil
        case .addCriterion, .pickQualificationTopics,
             .minimumReleaseDate(_), .maximumReleaseDate(_), .performSearch:
            return indexPath
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let row = sections_[indexPath.section].rows[indexPath.row]
        
        switch row
        {
        case .addCriterion:
            performSegue(withIdentifier: SctSearchViewController.toSctSearchPicker, sender: self)
        case .criterion(_), .qualificationTopic(_),
             .minimumQuestionsCount(_), .maximumQuestionsCount(_),
             .minimumDurationPicker, .maximumDurationPicker:
            break
        case let .minimumReleaseDate(date):
            currentIndexPath_ = indexPath
            pickMinimumDate_ = true
            minimumDate_ = date
            performSegue(withIdentifier: SctSearchViewController.toDatePicker, sender: self)
        case let .maximumReleaseDate(date):
            currentIndexPath_ = indexPath
            pickMinimumDate_ = false
            maximumDate_ = date
            performSegue(withIdentifier: SctSearchViewController.toDatePicker, sender: self)
        case .pickQualificationTopics:
            currentIndexPath_ = indexPath
            performSegue(withIdentifier: SctSearchViewController.toQualificationTopics, sender: self)
        case .performSearch:
            if !criteria_.isEmpty
            {
                performSegue(withIdentifier: SctSearchViewController.toSctSearchResult, sender: self)
            }
            else
            {
                checkSearchAll_()
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DELEGATE EDIT
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        let row = sections_[indexPath.section].rows[indexPath.row]
        
        switch row
        {
        case .addCriterion, .criterion(_):
            return true
        case .qualificationTopic(_), .pickQualificationTopics,
             .minimumQuestionsCount(_), .maximumQuestionsCount(_),
             .minimumReleaseDate(_), .maximumReleaseDate(_),
             .minimumDurationPicker, .maximumDurationPicker, .performSearch:
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
        case .qualificationTopic(_), .pickQualificationTopics,
             .minimumQuestionsCount(_), .maximumQuestionsCount(_),
             .minimumReleaseDate(_), .maximumReleaseDate(_),
             .minimumDurationPicker, .maximumDurationPicker, .performSearch:
            return .none
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        let row = sections_[indexPath.section].rows[indexPath.row]
        
        switch row
        {
        case .addCriterion:
            performSegue(withIdentifier: SctSearchViewController.toSctSearchPicker, sender: self)
        case .criterion(_):
            removeCriterion_(indexPath: indexPath)
        default:
            break
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DATA SOURCE
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
        switch pickedCriterion
        {
        case let .questionsCount(minimumQuestions, maximumQuestions):
            minimumQuestionsCount_ = minimumQuestions
            maximumQuestionsCount_ = maximumQuestions
        case let .releaseDate(minimumDate, maximumDate):
            minimumDate_ = minimumDate
            maximumDate_ = maximumDate
        default:
            break
        }
        
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

// -----------------------------------------------------------------------------
// MARK: - DATE PICKER DELEGATE
// -----------------------------------------------------------------------------
extension SctSearchViewController: DatePickerDelegate
{
    func datePicker(_ datePickerViewController: DatePickerViewController, didPickDate date: Date)
    {
        if pickMinimumDate_
        {
            minimumDate_ = date
        }
        else
        {
            maximumDate_ = date
        }
        
        guard currentIndexPath_ != nil else
        {
            return
        }
        
        let newReleaseDate = SctSearchCriterion.releaseDate(minimumDate_, maximumDate_)
        let sectionIndex = currentIndexPath_!.section
        criteria_[sectionIndex] = newReleaseDate
        tableView.reloadSections(IndexSet([sectionIndex]), with: .automatic)
    }
}

// -----------------------------------------------------------------------------
// MARK: - UI TEXT FIELD DELEGATE
// -----------------------------------------------------------------------------
extension SctSearchViewController: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        for character in string
        {
            if Int("\(character)") == nil
            {
                return false
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        let typedValue = Int(textField.text ?? "") ?? 0
        let newValue = Constants.bound(typedValue, min: 0, max: Sct.maximumTotalItemsCount)
        if textField.tag == SctSearchViewController.minimumTag_
        {
            if newValue > maximumQuestionsCount_
            {
                maximumQuestionsCount_ = newValue
                maximumQuestionsTextField_?.text = "\(newValue)"
            }
            minimumQuestionsCount_ = newValue
            minimumQuestionsTextField_?.text = "\(newValue)"
        }
        else
        {
            if newValue < minimumQuestionsCount_
            {
                minimumQuestionsCount_ = newValue
                minimumQuestionsTextField_?.text = "\(newValue)"
            }
            maximumQuestionsCount_ = newValue
            maximumQuestionsTextField_?.text = "\(newValue)"
        }
        
        criteria_[questionsCountCriterionIndex_] = .questionsCount(minimumQuestionsCount_, maximumQuestionsCount_)
    }
}
