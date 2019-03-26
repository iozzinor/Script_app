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
                    return "Signin.Section.Title.Qualifications".localized
                default:
                    return String.localizedStringWithFormat("Signin.Section.Title.Qualification".localized, qualification.name)
                }
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
                var result = [ SigninRow.qualification(qualification) ]
                switch qualification
                {
                case .student:
                    return result
                case let .teacher(topics):
                    for topic in topics
                    {
                        result.append(.qualificationTopic(topic))
                    }
                case let .expert(topics):
                    for topic in topics
                    {
                        result.append(.qualificationTopic(topic))
                    }
                }
                result.append(.newQualificationTopic)
                return result
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
        case newQualificationTopic
        
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
            case .userName, .password, .passwordVerification, .qualification(_), .qualificationTopic(_), .newQualification, .newQualificationTopic, .mailAddress, .securityQuestion(_):
                return true
            case .phoneNumber, .age, .address, .newSecurityQuestion, .submission, .error(_):
                return false
            }
        }
        
        func cell(for indexPath: IndexPath, tableView: UITableView, textFieldDelegate: UITextFieldDelegate, tag: Int) -> UITableViewCell
        {
            switch self
            {
            // account
            case .userName:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SigninLabelCell
                cell.label.text = "Signin.Form.Label.Username".localized
                cell.textField.tag = tag
                cell.textField.delegate = textFieldDelegate
                cell.textField.isSecureTextEntry = false
                return cell
            case .password:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SigninLabelCell
                cell.label.text = "Signin.Form.Label.Password".localized
                cell.textField.tag = tag
                cell.textField.delegate = textFieldDelegate
                cell.textField.textContentType = UITextContentType.password
                cell.textField.isSecureTextEntry = true
                return cell
            case .passwordVerification:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SigninLabelCell
                cell.label.text = "Signin.Form.Label.PasswordVerification".localized
                cell.textField.tag = tag
                cell.textField.delegate = textFieldDelegate
                cell.textField.textContentType = UITextContentType.password
                cell.textField.isSecureTextEntry = true
                return cell
                
            // qualification
            case let .qualification(qualification):
                let result = UITableViewCell()
                result.textLabel?.text = String.localizedStringWithFormat("Signin.Form.Label.Qualification".localized, qualification.name.uppercased())
                return result
            case let .qualificationTopic(qualificationTopic):
                let result = UITableViewCell()
                result.textLabel?.text = qualificationTopic.name
                return result
            case .newQualification:
                let result = UITableViewCell()
                result.textLabel?.textColor = Appearance.Color.action
                result.textLabel?.text = "Signin.Form.Label.NewQualification".localized
                return result
            case . newQualificationTopic:
                let result = UITableViewCell()
                result.textLabel?.textColor = Appearance.Color.action
                result.textLabel?.text = "Signin.Form.Label.NewQualificationTopic".localized
                return result
                
            // personal data
            case .mailAddress:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SigninLabelCell
                cell.label.text = "Signin.Form.Label.MailAddress".localized
                cell.textField.tag = tag
                cell.textField.delegate = textFieldDelegate
                cell.textField.isSecureTextEntry = false
                return cell
            case .phoneNumber:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SigninLabelCell
                cell.label.text = "Signin.Form.Label.PhoneNumber".localized
                cell.textField.tag = tag
                cell.textField.delegate = textFieldDelegate
                cell.textField.isSecureTextEntry = false
                return cell
            case .age:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SigninLabelCell
                cell.label.text = "Signin.Form.Label.Age".localized
                cell.textField.tag = tag
                cell.textField.delegate = textFieldDelegate
                cell.textField.isSecureTextEntry = false
                return cell
            case .address:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SigninLabelCell
                cell.label.text = "Signin.Form.Label.Address".localized
                cell.textField.tag = tag
                cell.textField.delegate = textFieldDelegate
                cell.textField.isSecureTextEntry = false
                return cell
                
            // security question
            case let .securityQuestion(securityQuestion):
                let cell = tableView.dequeueReusableCell(for: indexPath) as SecurityQuestionCell
                cell.setup(for: indexPath, securityQuestion: securityQuestion)
                cell.answer.delegate = textFieldDelegate
                cell.answer.tag = tag
                return cell
            case .newSecurityQuestion:
                let cell = UITableViewCell()
                cell.textLabel?.text = "Signin.Form.Label.NewSecurityQuestion".localized
                cell.textLabel?.textColor = Appearance.Color.action
                return cell
                
            case .submission:
                let result = UITableViewCell()
                result.textLabel?.textColor = Appearance.Color.action
                result.textLabel?.textAlignment = .center
                result.textLabel?.text = "Signin.Form.Label.Submit".localized
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
                 .qualification(_), .qualificationTopic(_), .newQualification, .newQualificationTopic, .mailAddress,
                 .phoneNumber, .age, .address,
                 .newSecurityQuestion, .submission, .error(_):
                return .none
            case .securityQuestion(_):
                return .disclosureIndicator
            }
        }
        
        func isValid(forValue value: String, cache: SigninCache) -> Bool
        {
            switch self
            {
            case .userName:
                return value.count > 5
            case .password:
                return PasswordPolicy.shared.isValid(password: value)
            case .passwordVerification:
                return !cache.passwordVerification.isEmpty && cache.password == value
                
            // qualification
            case .qualification(_), .qualificationTopic(_), .newQualification, .newQualificationTopic:
                return true
                
            // personal data
            case .mailAddress:
                let mailRegularExpression = try! NSRegularExpression(pattern: "^([A-Za-z0-9+-_.])+@([A-Za-z0-9+-_.])+[.]([A-Za-z0-9+-_.])+$", options: [.anchorsMatchLines])
                let range = NSRange(location: 0, length: value.count)
                return mailRegularExpression.matches(in: value, options: [], range: range).count > 0
            case .phoneNumber:
                return true
            case .age:
                return true
            case .address:
               return true
                
            // security question
            case .securityQuestion(_):
                return !value.isEmpty
            case .newSecurityQuestion, .submission, .error(_):
                return true
            }
        }
        
        func updateCell(_ cell: UITableViewCell, valid: Bool, value: String)
        {
            switch self
            {
            case .userName, .password, .passwordVerification,
                 .mailAddress, .phoneNumber, .age, .address:
                let signinLabelCell = cell as! SigninLabelCell
                signinLabelCell.label.textColor = valid ? UIColor.black : UIColor.red
                signinLabelCell.textField.text = value
                
            case .securityQuestion(_):
                let signinSecurityQuestionCell = cell as! SecurityQuestionCell
                signinSecurityQuestionCell.questionHeading.textColor = valid ? UIColor.black : UIColor.red
                signinSecurityQuestionCell.answer.text = value
               
            default:
                break
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - CACHE
    // -------------------------------------------------------------------------
    fileprivate struct SigninCache
    {
        var submitted = false
        
        // account
        var username: String = ""
        var password: String = ""
        var passwordVerification: String = ""
        
        // qualification
        var qualificationToUpdateIndex = IndexPath()
        var qualifications: [Qualification] = []
        
        func qualificationIndexForSection(_ sectionIndex: Int) -> Int
        {
            var index = -1
            
            let currentSections = sections
            for (i, section) in currentSections.enumerated()
            {
                if i > sectionIndex
                {
                    break
                }
                
                switch section
                {
                case .qualification(_):
                    index += 1
                default:
                    break
                }
            }
            
            return index
        }
        
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
        
        // sections
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
        
        func tag(for indexPath: IndexPath) -> Int
        {
            var result = 0
            
            let currentSections = sections
            for (i, section) in currentSections.enumerated()
            {
                if i > indexPath.section - 1
                {
                    break
                }
                if i < currentSections.count - 1
                {
                    result += section.rows.count
                }
            }
            result += indexPath.row
            
            return result
        }
        
        // value
        func value(for indexPath: IndexPath) -> String
        {
            let section = sections[indexPath.section]
            let row = section.rows[indexPath.row]
            
            switch row
            {
            case .userName:
                return username
            case .password:
                return password
            case .passwordVerification:
                return passwordVerification
                
            case .qualification(_), .qualificationTopic(_), .newQualification, .newQualificationTopic:
                return ""
                
            case .mailAddress:
                return mailAddress
            case .phoneNumber:
                return phoneNumber
            case .age:
                return age
            case .address:
                return address
                
            case let .securityQuestion(securityQuestion):
                return securityQuestion.answer
            case .newSecurityQuestion, .submission, .error(_):
                return ""
            }
        }
        
        mutating func set(value: String, for indexPath: IndexPath)
        {
            let section = sections[indexPath.section]
            let row = section.rows[indexPath.row]
            
            switch row
            {
            case .userName:
                username = value
            case .password:
                password = value
            case .passwordVerification:
                passwordVerification = value
                
            case .qualification(_), .qualificationTopic(_), .newQualification, .newQualificationTopic:
                break
                
            case .mailAddress:
                mailAddress = value
            case .phoneNumber:
                phoneNumber = value
            case .age:
                 age = value
            case .address:
                 address = value
                
            case var .securityQuestion(securityQuestion):
                securityQuestion.answer = value
                securityQuestions[indexPath.row] = securityQuestion
            case .newSecurityQuestion, .submission, .error(_):
                break
            }
        }
    }
    
    static let toQualificationPicker = "SigninToQualificationPickerSegueId"
    static let toQualificationTopicPicker = "SigninToQualificationTopicPickerSegueId"
    static let toSecurityQuestionPicker = "SigninToSecurityQuestionPickerSegueId"
    
    fileprivate var cache_ = SigninCache()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.allowsSelectionDuringEditing = true
        tableView.isEditing = true
        
        tableView.register(UINib(nibName: "SecurityQuestionCell", bundle: nil), forCellReuseIdentifier: SecurityQuestionCell.reuseId)
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
        cache_.submitted = true
        tableView.reloadData()
    }
    
    fileprivate func addQualification_()
    {
        performSegue(withIdentifier: SigninViewController.toQualificationPicker, sender: self)
    }
    
    fileprivate func addQualificationTopic_()
    {
        performSegue(withIdentifier: SigninViewController.toQualificationTopicPicker, sender: self)
    }
    
    fileprivate func deleteQualification_()
    {
        if cache_.qualifications.first! == .student
        {
            cache_.qualifications = []
            tableView.reloadSections(IndexSet([cache_.qualificationToUpdateIndex.section]), with: .automatic)
        }
        else if cache_.qualifications.count == 1
        {
            cache_.qualifications = []
            tableView.deleteSections(IndexSet([cache_.qualificationToUpdateIndex.section]), with: .automatic)
        }
        else
        {
            let qualificationIndex = cache_.qualificationIndexForSection(cache_.qualificationToUpdateIndex.section)
            let removedQualification = cache_.qualifications.remove(at: qualificationIndex)
            let topics: [QualificationTopic]
            switch removedQualification
            {
            case .student:
                return
            case let .expert(qualificationTopics):
                topics = qualificationTopics
            case let .teacher(qualificationTopics):
                topics = qualificationTopics
            }
            
            switch qualificationIndex
            {
            case 0:
                tableView.beginUpdates()
                tableView.deleteSections(IndexSet([cache_.qualificationToUpdateIndex.section]), with: .automatic)
                tableView.insertSections(IndexSet([cache_.qualificationToUpdateIndex.section + 1]), with: .automatic)
                tableView.insertRows(at: [IndexPath(row: 0, section: cache_.qualificationToUpdateIndex.section + 1)
                    ], with: .automatic)
                tableView.endUpdates()
            case 1:
                tableView.beginUpdates()
                for i in 1..<(topics.count + 2)
                {
                    let row = topics.count + 2 - i
                    
                    tableView.deleteRows(at: [IndexPath(row: row, section: cache_.qualificationToUpdateIndex.section)], with: .automatic)
                }
                tableView.endUpdates()
                tableView.reloadRows(at: [IndexPath(row: 0, section: cache_.qualificationToUpdateIndex.section)], with: .automatic)
            default:
                break
            }
        }
    }
    
    fileprivate func deleteQualificationTopic_()
    {
        let qualificationIndex = cache_.qualificationIndexForSection(cache_.qualificationToUpdateIndex.section)
        let qualificationTopicIndex = cache_.qualificationToUpdateIndex.row - 1
        
        let qualification = cache_.qualifications[qualificationIndex]
        
        switch qualification
        {
        case .student:
            return
        case var .teacher(topics):
            topics.remove(at: qualificationTopicIndex)
            cache_.qualifications[qualificationIndex] = .teacher(topics)
        case var .expert(topics):
            topics.remove(at: qualificationTopicIndex)
            cache_.qualifications[qualificationIndex] = .expert(topics)
        }
        
        tableView.deleteRows(at: [cache_.qualificationToUpdateIndex], with: .automatic)
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
        else if segue.identifier == SigninViewController.toQualificationPicker,
            let target = segue.destination as? QualificationPickerViewController
        {
            target.qualificationDelegate = self
            target.pickedQualifications = cache_.qualifications
            
            if !cache_.qualifications.isEmpty && !cache_.qualifications.contains(.student)
            {
                var currentQualifications = cache_.qualifications
                currentQualifications.append(.student)
                target.pickedQualifications = currentQualifications
            }
        }
        else  if segue.identifier == SigninViewController.toQualificationTopicPicker,
                let target = segue.destination as? QualificationTopicPickerViewController
        {
            var currentTopics = [QualificationTopic]()
            
            for qualification in cache_.qualifications
            {
                switch qualification
                {
                case let .teacher(topics):
                    currentTopics.append(contentsOf: topics)
                case let .expert(topics):
                    currentTopics.append(contentsOf: topics)
                case .student:
                    break
                }
            }
            target.pickedQualificationTopics = currentTopics
            target.qualificationTopicDelegate = self
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
        case .qualification(_), .qualificationTopic(_), .newQualification, .newQualificationTopic, .newSecurityQuestion:
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
        case .newQualification, .newQualificationTopic, .newSecurityQuestion:
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
        case .newQualification:
            cache_.qualificationToUpdateIndex = indexPath
            addQualification_()
        case .qualification(_):
            cache_.qualificationToUpdateIndex = indexPath
            deleteQualification_()
        case .qualificationTopic(_):
            cache_.qualificationToUpdateIndex = indexPath
            deleteQualificationTopic_()
        case .newQualificationTopic:
            cache_.qualificationToUpdateIndex = indexPath
            addQualificationTopic_()
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
        case .newQualification:
            cache_.qualificationToUpdateIndex = indexPath
            addQualification_()
        case .newQualificationTopic:
            cache_.qualificationToUpdateIndex = indexPath
            addQualificationTopic_()
        case .securityQuestion(_):
            cache_.questionToUpdateIndex = indexPath
            performSegue(withIdentifier: SigninViewController.toSecurityQuestionPicker, sender: self)
        case .newSecurityQuestion:
            addSecurityQuestion_(newQuestionIndexPath: indexPath)
        case .submission:
            submit_()
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
        
        let cell = row.cell(for: indexPath, tableView: tableView,
                            textFieldDelegate: self, tag: cache_.tag(for: indexPath))
        cell.accessoryType = row.accessoryType
        cell.selectionStyle = .none
        if let signinLabelCell = cell as? SigninLabelCell
        {
            signinLabelCell.textField?.placeholder = row.isRequired ? "Signin.Form.TextField.Required".localized : "Signin.Form.TextField.Optional".localized
        }
        
        if cache_.submitted
        {
            let value = cache_.value(for: indexPath)
            let isValid = row.isValid(forValue: value, cache: cache_)
            row.updateCell(cell, valid: isValid, value: value)
        }
        
        return cell
    }
}

// -----------------------------------------------------------------------------
// MARK: - QualificationPickerViewControllerDelegate
// -----------------------------------------------------------------------------
extension SigninViewController: QualificationPickerViewControllerDelegate
{
    func qualificationPickerViewController(_ qualificationPickerViewController: QualificationPickerViewController, didPickQualification qualification: Qualification)
    {
        // refuse qualifications if the current one is student
        if (cache_.qualifications.first ?? .expert([])) == .student
        {
            return
        }
        // accept all the qualifications if the current array is empty
        else if cache_.qualifications.isEmpty
        {
            switch qualification
            {
            case .student:
                cache_.qualifications.append(qualification)
                tableView.reloadSections(IndexSet([cache_.qualificationToUpdateIndex.section]), with: .automatic)
            case .expert(_), .teacher(_):
                cache_.qualifications.append(qualification)
                
                let newSection = cache_.qualificationToUpdateIndex.section + 1
                
                tableView.beginUpdates()
                tableView.insertSections(IndexSet([newSection]), with: .automatic)
                tableView.insertRows(at: [IndexPath(row: 1, section: cache_.qualificationToUpdateIndex.section), IndexPath(row: 0, section: newSection)], with: .automatic)
                tableView.endUpdates()
                
                tableView.reloadSections(IndexSet([cache_.qualificationToUpdateIndex.section]), with: .automatic)
            }
        }
        // accept new teacher or new expert
        else if cache_.qualifications.count == 1
        {
            switch cache_.qualifications.first!
            {
            case .teacher(_):
                cache_.qualifications.append(qualification)
                
                tableView.insertRows(at: [IndexPath(row: 1, section: cache_.qualificationToUpdateIndex.section)], with: .automatic)
                tableView.reloadSections(IndexSet([cache_.qualificationToUpdateIndex.section]), with: .automatic)
            case .expert(_):
                cache_.qualifications.insert(qualification, at: 0)
                let newSection = cache_.qualificationToUpdateIndex.section
                
                tableView.beginUpdates()
                tableView.deleteSections(IndexSet([newSection]), with: .automatic)
                tableView.insertSections(IndexSet([newSection - 1]), with: .automatic)
                tableView.insertRows(at: [IndexPath(row: 0, section: newSection - 1), IndexPath(row: 1, section: newSection - 1)], with: .automatic)
                tableView.endUpdates()
                
            default:
                break
            }
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - QualificationTopicPickerViewControllerDelegate
// -----------------------------------------------------------------------------
extension SigninViewController: QualificationTopicPickerViewControllerDelegate
{
    func qualificationTopicPickerViewController(_ qualificationTopicPickerViewController: QualificationTopicPickerViewController, didPickQualificationTopic qualificationTopic: QualificationTopic)
    {
        let qualificationIndex = cache_.qualificationIndexForSection(cache_.qualificationToUpdateIndex.section)
        let qualification = cache_.qualifications[qualificationIndex]
        
        var newTopics: [QualificationTopic]
        switch qualification
        {
        case .student:
            return
        case let .teacher(topics):
            newTopics = topics
        case let .expert(topics):
            newTopics = topics
        }
        
        newTopics.append(qualificationTopic)
        newTopics.sort(by: { $0.rawValue < $1.rawValue })
        
        switch qualification
        {
        case .student:
            break
        case .teacher(_):
            cache_.qualifications[qualificationIndex] = .teacher(newTopics)
        case .expert(_):
            cache_.qualifications[qualificationIndex] = .expert(newTopics)
        }
        
        tableView.insertRows(at: [IndexPath(row: newTopics.count + 1, section: cache_.qualificationToUpdateIndex.section)], with: .automatic)
        tableView.reloadSections(IndexSet([cache_.qualificationToUpdateIndex.section]), with: .automatic)
    }
}

// -----------------------------------------------------------------------------
// MARK: - SecurityQuestionPickerViewControllerDelegate
// -----------------------------------------------------------------------------
extension SigninViewController: SecurityQuestionPickerViewControllerDelegate
{
    func securityQuestionPickerViewController(_ securityQuestionPickerViewController: SecurityQuestionPickerViewController, didPickSecurityQuestion securityQuestion: SecurityQuestion.Heading?)
    {
        cache_.securityQuestions[cache_.questionToUpdateIndex.row] = SecurityQuestion(heading: securityQuestion!, answer: "")
        
        tableView.reloadRows(at: [cache_.questionToUpdateIndex], with: .automatic)
    }
}

// -----------------------------------------------------------------------------
// MARK: - TextFieldDelegate
// -----------------------------------------------------------------------------
extension SigninViewController: UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason)
    {
        // retrieve the index path
        let sections = cache_.sections
        var currentTag = textField.tag
        var indexPath = IndexPath(row: 0, section: 0)
        
        for (sectionIndex, section) in sections.enumerated()
        {
            let rows = section.rows
            
            if currentTag < rows.count
            {
                indexPath.section = sectionIndex
                indexPath.row = currentTag
                break
            }
            currentTag -= rows.count
        }
        
        cache_.set(value: textField.text ?? "", for: indexPath)
    }
}
