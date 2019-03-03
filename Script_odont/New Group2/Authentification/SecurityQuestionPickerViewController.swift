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
        let pickedQuestion = questions_[indexPath.row]
        
        pickerDelegate?.securityQuestionPickerViewController(self, didPickSecurityQuestion: pickedQuestion)
        
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
        return questions_.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: SecurityQuestionPickerViewController.cellId, for: indexPath)
        cell.textLabel?.text = questions_[indexPath.row].content
        return cell
    }
}
