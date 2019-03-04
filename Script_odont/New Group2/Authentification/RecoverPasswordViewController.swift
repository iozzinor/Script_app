//
//  RecoverPasswordViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 03/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class RecoverPasswordViewController: UITableViewController
{
    // -------------------------------------------------------------------------
    // MARK: - SECTION
    // -------------------------------------------------------------------------
    fileprivate enum RecoverPasswordSection
    {
        case accountInformation
        case securityQuestions([SecurityQuestion?])
        case recover
        
        var headerTitle: String?
        {
            switch self
            {
            case .accountInformation:
                return "RecoverPassword.Header.AccountInformation".localized
            case .securityQuestions(_):
                return "RecoverPassword.Header.SecurityQuestions".localized
            case .recover:
                return nil
            }
        }
        
        var rows: [RecoverPasswordRow]
        {
            switch self
            {
            case .accountInformation:
                return [ .userIdentifier ]
            case let .securityQuestions(securityQuestions):
                return securityQuestions.map { RecoverPasswordRow.securityQuestion($0) }
            case .recover:
                return [ .recover ]
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ROWS
    // -------------------------------------------------------------------------
    fileprivate enum RecoverPasswordRow
    {
        case userIdentifier
        case securityQuestion(SecurityQuestion?)
        case recover
        
        func cell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell
        {
            switch self
            {
            case .userIdentifier:
                let cell = tableView.dequeueReusableCell(for: indexPath) as UserIdentifierCell
                cell.identifierLabel.text = "RecoverPassword.UserIdentifier.Label".localized
                cell.identifierTextField.placeholder = "RecoverPassword.UserIdentifier.TextField".localized
                return cell
            case let .securityQuestion(securityQuestion):
                let cell = tableView.dequeueReusableCell(for: indexPath) as SecurityQuestionCell
                cell.setup(for: indexPath, securityQuestion: securityQuestion)
                cell.accessoryType = .disclosureIndicator
                return cell
            case .recover:
                let cell = UITableViewCell()
                cell.textLabel?.textColor = Appearance.Color.action
                cell.textLabel?.text = "RecoverPassword.Action.Recover".localized
                cell.accessoryType = .none
                return cell
            }
        }
    }
    
    static let toSecurityQuestionPicker = "RecovePasswordToSecurityQuestionPickerSegueId"
    
    fileprivate var questions_ = [
        SecurityQuestion(heading: .childhoodCity, answer: ""),
        SecurityQuestion(heading: .parentMeetingCity, answer: ""),
        SecurityQuestion(heading: .childhoodStreet, answer: ""),
        nil,
        nil
    ]
    fileprivate var sections_: [RecoverPasswordSection] {
        return [ .accountInformation, .securityQuestions(questions_), .recover]
    }
    fileprivate var questionIndex_ = IndexPath()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "SecurityQuestionCell", bundle: nil), forCellReuseIdentifier: SecurityQuestionCell.reuseId)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUE
    // -------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == RecoverPasswordViewController.toSecurityQuestionPicker,
            let target = segue.destination as? SecurityQuestionPickerViewController
        {
            target.optional = questionIndex_.row > 2
            target.pickedQuestions = try! questions_.filter {
                (question) throws -> Bool in
                return question != nil
            }.map { $0!.heading }
            target.pickerDelegate = self
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @IBAction func cancel(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem)
    {
        recover_()
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func recover_()
    {
        
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDelegate
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        let section = sections_[indexPath.section]
        let row = section.rows[indexPath.row]
        switch row
        {
        case .userIdentifier, .recover:
            return nil
        case .securityQuestion(_):
            return indexPath
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let section = sections_[indexPath.section]
        let row = section.rows[indexPath.row]
        switch row
        {
        case .userIdentifier, .recover:
            break
        case .securityQuestion(_):
            questionIndex_ = indexPath
            performSegue(withIdentifier: RecoverPasswordViewController.toSecurityQuestionPicker, sender: self)
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDataSource
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let currentSection = sections_[section]
        return currentSection.headerTitle
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return sections_.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let currentSection = sections_[section]
        return currentSection.rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = sections_[indexPath.section]
        let row = section.rows[indexPath.row]
        
        let cell = row.cell(for: indexPath, tableView: tableView)
        cell.selectionStyle = .none
        return cell
    }
}

// -------------------------------------------------------------------------
// MARK: - SecurityQuestionPickerViewControllerDelegate
// -------------------------------------------------------------------------
extension RecoverPasswordViewController: SecurityQuestionPickerViewControllerDelegate
{
    func securityQuestionPickerViewController(_ securityQuestionPickerViewController: SecurityQuestionPickerViewController, didPickSecurityQuestion securityQuestion: SecurityQuestion.Heading?)
    {
        if let heading = securityQuestion
        {
            questions_[questionIndex_.row] = SecurityQuestion(heading: heading, answer: "")
        }
        else
        {
            questions_[questionIndex_.row] = nil
        }
        tableView.reloadRows(at: [questionIndex_], with: .automatic)
    }
}
