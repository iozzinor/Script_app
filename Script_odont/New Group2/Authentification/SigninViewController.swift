//
//  SigninViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 02/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SigninViewController: UITableViewController
{
    // -------------------------------------------------------------------------
    // MARK: - SECTIONS
    // -------------------------------------------------------------------------
    fileprivate enum SigninSection
    {
        case account
        case qualification(Qualification)
        case newQualification
        case personalData
        case securityQuestions([SecurityQuestion])
        case newSecurityQuestion
        case submission
        case error(String)
        
        func headerTitle(for signinViewController: SigninViewController) ->  String?
        {
            switch self
            {
            case .account:
                return "Signin.Section.Title.Account".localized
            case let .qualification(qualification):
                switch qualification
                {
                case .student:
                    return nil
                default:
                    break
                }
                
                return String.localizedStringWithFormat("Signin.Section.Title.Qualification".localized, qualification.name)
            case .newQualification:
                if signinViewController.cache_.qualifications.isEmpty
                {
                    return "Signin.Section.Title.Qualifications".localized
                }
                return nil
            case .personalData:
                return "Signin.Section.Title.PersonalData".localized
            case .securityQuestions(_):
                return "Signin.Section.Title.SecurityQuestions".localized
            case .newSecurityQuestion, .submission, .error:
                return nil
            }
        }
        
        var rows: [SigninRow] {
            switch self
            {
            case .account:
                return [ .userName, .password, .passwordVerification ]
            case let .qualification(qualification):
                return [ .qualification(qualification) ]
            case .newQualification:
                return [ .newQualification ]
            case .personalData:
                return [ .mailAddress, .phoneNumber, .age, .address ]
            case let .securityQuestions(securityQuestions):
                var result = [SigninRow]()
                for securityQuestion in securityQuestions
                {
                    result.append(.securityQuestion(securityQuestion))
                }
                return result
            case .newSecurityQuestion:
                return [ .newSecurityQuestion ]
            case .submission:
                return [.submission]
            case let .error(string):
                return [.error(string)]
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ROWS
    // -------------------------------------------------------------------------
    fileprivate enum SigninRow
    {
        case userName
        case password
        case passwordVerification
        
        case qualification(Qualification)
        case qualificationTopic(QualificationTopic)
        case newQualification
        
        case mailAddress
        case phoneNumber
        case age
        case address
        
        case securityQuestion(SecurityQuestion)
        case newSecurityQuestion
        
        case submission
        
        case error(String)
        
        var isRequired: Bool {
            switch self
            {
            case .userName, .password, .passwordVerification, .qualification(_), .qualificationTopic(_), .newQualification, .mailAddress, .securityQuestion(_):
                return true
            case .phoneNumber, .age, .address, .newSecurityQuestion, .submission, .error(_):
                return false
            }
        }
        
        func cell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell
        {
            switch self
            {
            // account
            case .userName:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SigninLabelCell
                cell.label.text = "Username:"
                return cell
            case .password:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SigninLabelCell
                cell.label.text = "Password:"
                cell.textField.textContentType = UITextContentType.password
                cell.textField.isSecureTextEntry = true
                return cell
            case .passwordVerification:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SigninLabelCell
                cell.label.text = "Password check:"
                cell.textField.textContentType = UITextContentType.password
                cell.textField.isSecureTextEntry = true
                return cell
                
            // qualification
            case let .qualification(qualification):
                let result = UITableViewCell()
                result.textLabel?.text = "Qualification \(qualification.name.uppercased())"
                return result
            case let .qualificationTopic(qualificationTopic):
                let result = UITableViewCell()
                result.textLabel?.text = qualificationTopic.name
                return result
            case .newQualification:
                let result = UITableViewCell()
                result.textLabel?.textColor = Appearance.Color.action
                result.textLabel?.text = "New qualification"
                return result
                
            // personal data
            case .mailAddress:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SigninLabelCell
                cell.label.text = "Mail Address:"
                return cell
            case .phoneNumber:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SigninLabelCell
                cell.label.text = "Phone Number:"
                return cell
            case .age:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SigninLabelCell
                cell.label.text = "Age:"
                return cell
            case .address:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SigninLabelCell
                cell.label.text = "Address:"
                return cell
                
            // security question
            case let .securityQuestion(securityQuestion):
                let cell = tableView.dequeueReusableCell(for: indexPath) as SigninSecurityQuestionCell
                cell.setup(for: indexPath, securityQuestion: securityQuestion)
                return cell
            case .newSecurityQuestion:
                let cell = UITableViewCell()
                cell.textLabel?.text = "New security question"
                cell.textLabel?.textColor = Appearance.Color.action
                return cell
                
            case .submission:
                let result = UITableViewCell()
                result.textLabel?.textColor = Appearance.Color.action
                result.textLabel?.textAlignment = .center
                result.textLabel?.text = "Submit"
                return result
                
            case let .error(message):
                let result = UITableViewCell()
                result.textLabel?.text = message
                return result
            }
        }
        
        var accessoryType: UITableViewCell.AccessoryType
        {
            switch self
            {
            case .userName, .password, .passwordVerification,
                 .qualification(_), .qualificationTopic(_), .newQualification, .mailAddress,
                 .phoneNumber, .age, .address,
                 .newSecurityQuestion, .submission, .error(_):
                return .none
            case .securityQuestion(_):
                return .disclosureIndicator
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - CACHE
    // -------------------------------------------------------------------------
    fileprivate struct SigninCache
    {
        // account
        var username: String = ""
        var password: String = ""
        
        // qualification
        var qualifications: [Qualification] = []
        
        // personal data
        var mailAddress: String = ""
        var phoneNumber: String = ""
        var age: String = ""
        var address: String = ""
        
        // security questions
        var securityQuestions: [SecurityQuestion] = [
            SecurityQuestion(heading: .childhoodCity, answer: ""),
            SecurityQuestion(heading: .parentMeetingCity, answer: ""),
            SecurityQuestion(heading: .childhoodStreet, answer: "")
        ]
        var questionToUpdateIndex = IndexPath()
        
        var sections: [SigninSection] {
            var result = [ SigninSection.account ]
            
            // qualification
            for qualification in qualifications
            {
                result.append(.qualification(qualification))
            }
            if qualifications.isEmpty
            {
                result.append(.newQualification)
            }
            else
            {
                switch qualifications.first!
                {
                case .student:
                    break;
                default:
                    if qualifications.count == 1
                    {
                        result.append(.newQualification)
                    }
                }
            }
            
            // personal data
            result.append(.personalData)
            
            // security questions
            result.append(.securityQuestions(securityQuestions))
            if securityQuestions.count < 5
            {
                result.append(.newSecurityQuestion)
            }
            
            // submission
            result.append(.submission)
            
            return result
        }
    }
    
    static let toSecurityQuestionPicker = "SigninToSecurityQuestionPickerSegueId"
    
    fileprivate var cache_ = SigninCache()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.allowsSelectionDuringEditing = true
        tableView.isEditing = true
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
        submit_()
    }
    
    fileprivate func submit_()
    {
        
    }
    
    fileprivate func deleteSecurityQuestion_(atPath indexPath: IndexPath)
    {
        cache_.securityQuestions.remove(at: indexPath.row)
        
        tableView.beginUpdates()
        
        if cache_.securityQuestions.count == 4
        {
            let newQuestionIndexPath = IndexPath(row: 0, section: indexPath.section + 1)
            tableView.insertSections(IndexSet([indexPath.section + 1]), with: .automatic)
            tableView.insertRows(at: [newQuestionIndexPath], with: .automatic)
        }
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        tableView.endUpdates()
        
        tableView.reloadSections(IndexSet([indexPath.section]), with: .automatic)
    }
    
    fileprivate func addSecurityQuestion_(newQuestionIndexPath: IndexPath)
    {
        let insertedQuestion = try! SecurityQuestion.Heading.allCases.filter {
            (question) throws -> Bool in
            
            return !cache_.securityQuestions.map{ $0.heading }.contains(question)
        }.first!
        
        cache_.securityQuestions.append(SecurityQuestion(heading: insertedQuestion, answer: ""))
        
        let insertedIndexPath = IndexPath(row: cache_.securityQuestions.count - 1, section: newQuestionIndexPath.section - 1)
        
        tableView.beginUpdates()
        tableView.insertRows(at: [insertedIndexPath], with: .automatic)
        
        if cache_.securityQuestions.count == 5
        {
            tableView.deleteSections(IndexSet([newQuestionIndexPath.section]), with: .automatic)
        }
        tableView.endUpdates()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUES
    // -------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == SigninViewController.toSecurityQuestionPicker,
            let target = segue.destination as? SecurityQuestionPickerViewController
        {
            target.pickedQuestions = cache_.securityQuestions.map { $0.heading }
            target.pickerDelegate = self
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDelegate
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        let section = cache_.sections[indexPath.section]
        let row = section.rows[indexPath.row]
        
        switch row
        {
        case .qualification(_), .qualificationTopic(_), .newQualification, .newSecurityQuestion:
            return true
        case .securityQuestion(_):
            return cache_.securityQuestions.count > 3
        default:
            break
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    {
        let section = cache_.sections[indexPath.section]
        let row = section.rows[indexPath.row]
        
        switch row
        {
        case .qualification(_), .qualificationTopic(_):
            return .delete
        case .newQualification, .newSecurityQuestion:
            return .insert
        case .securityQuestion(_):
            if cache_.securityQuestions.count > 3
            {
                return .delete
            }
            return .none
        default:
            break
        }
        return .none
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        let section = cache_.sections[indexPath.section]
        let row = section.rows[indexPath.row]
        
        switch row
        {
        case .securityQuestion(_):
            deleteSecurityQuestion_(atPath: indexPath)
        case .newSecurityQuestion:
            addSecurityQuestion_(newQuestionIndexPath: indexPath)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.selectRow(at: nil, animated: false, scrollPosition: .none)
        
        let section = cache_.sections[indexPath.section]
        let row = section.rows[indexPath.row]
        
        switch row
        {
        case .securityQuestion(_):
            cache_.questionToUpdateIndex = indexPath
            performSegue(withIdentifier: SigninViewController.toSecurityQuestionPicker, sender: self)
        case .newSecurityQuestion:
            addSecurityQuestion_(newQuestionIndexPath: indexPath)
        case .submission:
            print("submission")
        default:
            break
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDataSource
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let currentSection = cache_.sections[section]
        return currentSection.headerTitle(for: self)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return cache_.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let section = cache_.sections[section]
        
        return section.rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = cache_.sections[indexPath.section]
        let row = section.rows[indexPath.row]
        
        let cell = row.cell(for: indexPath, tableView: tableView)
        cell.accessoryType = row.accessoryType
        cell.selectionStyle = .none
        if let signinLabelCell = cell as? SigninLabelCell
        {
            signinLabelCell.textField?.placeholder = row.isRequired ? "Required" : "Optional"
        }
        return cell
    }
}

// -----------------------------------------------------------------------------
// MARK: - SecurityQuestionPickerViewControllerDelegate
// -----------------------------------------------------------------------------
extension SigninViewController: SecurityQuestionPickerViewControllerDelegate
{
    func securityQuestionPickerViewController(_ securityQuestionPickerViewController: SecurityQuestionPickerViewController, didPickSecurityQuestion securityQuestion: SecurityQuestion.Heading)
    {
        cache_.securityQuestions[cache_.questionToUpdateIndex.row] = SecurityQuestion(heading: securityQuestion, answer: "")
        
        tableView.reloadRows(at: [cache_.questionToUpdateIndex], with: .automatic)
    }
}
