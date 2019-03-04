//
//  SecurityQuestionPickerViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 03/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SecurityQuestionPickerViewController: UITableViewController
{
    static let cellId = "SecurityQuestionPickerCellReuseId"
    
    fileprivate var questions_ = SecurityQuestion.Heading.allCases
    
    var optional: Bool = false {
        didSet {
            if isViewLoaded
            {
                tableView.reloadData()
            }
        }
    }
    
    var pickedQuestions = [SecurityQuestion.Heading]() {
        didSet {
            // update questions
            
            questions_ = try! SecurityQuestion.Heading.allCases.filter {
                (question) throws -> Bool in
                
                return !pickedQuestions.contains(question)
            }
            
            if isViewLoaded
            {
                tableView.reloadData()
            }
        }
    }
    
    weak var pickerDelegate: SecurityQuestionPickerViewControllerDelegate? = nil
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDelegate
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if optional && indexPath.row == 0
        {
            pickerDelegate?.securityQuestionPickerViewController(self, didPickSecurityQuestion: nil)
        }
        else
        {
            let pickedQuestion = questions_[optional ? indexPath.row - 1 : indexPath.row]
            pickerDelegate?.securityQuestionPickerViewController(self, didPickSecurityQuestion: pickedQuestion)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDataSource
    // -------------------------------------------------------------------------
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if optional
        {
            return questions_.count + 1
        }
        return questions_.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: SecurityQuestionPickerViewController.cellId, for: indexPath)
        
        if optional && indexPath.row == 0
        {
            cell.textLabel?.text = "SecurityQuestionPicker.Label.None".localized
        }
        else
        {
            cell.textLabel?.text = questions_[optional ? indexPath.row - 1 : indexPath.row].content
        }
        
        return cell
    }
}
