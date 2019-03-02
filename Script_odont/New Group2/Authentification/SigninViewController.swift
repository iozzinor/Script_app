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
        case capabilities([Int])
        
        var rows: [SigninRow] {
            switch self
            {
            case .account:
                return [ .userName, .password, .passwordVerification ]
            case let .capabilities(numbers):
                
                var result = [SigninRow]()
                for number in numbers
                {
                    result.append(.capability(number))
                }
                
                return result
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
        case capability(Int)
        
        func cell(for indexPath: IndexPath, tableView: UITableView) -> UITableViewCell
        {
            let cell = tableView.dequeueReusableCell(for: indexPath) as SigninLabelCell
            switch self
            {
            case .userName:
                cell.label.text = "Username:"
                cell.textField.placeholder = "The username..."
            case .password:
                cell.label.text = "Password:"
                cell.textField.placeholder = "The password..."
            case .passwordVerification:
                cell.label.text = "Password verification:"
                cell.textField.placeholder = "Enter the same password again..."
            case let .capability(number):
                let result = UITableViewCell()
                result.textLabel?.text = "Capability \(number)"
                return result
            }
            return cell
        }
    }
    
    fileprivate var sections_: [ SigninSection ] = [ .account, .capabilities([1, 3, 4]) ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDelegate
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    {
        let section = sections_[indexPath.section]
        let row = section.rows[indexPath.row]
        
        switch row
        {
        case let .capability(number):
            if number < 2
            {
                //return .delete
                return .insert
            }
            
            return .insert
        default:
            break
        }
        return .none
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        let section = sections_[indexPath.section]
        let row = section.rows[indexPath.row]
        
        switch row
        {
        case .capability(_):
            return true
        default:
            break
        }
        return false
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        let section = sections_[indexPath.section]
        
        switch section
        {
        case let .capabilities(numbers):
            var newNumbers = numbers
            newNumbers.append(newNumbers.count + 1)
            let newSection = SigninSection.capabilities(newNumbers)
            
            sections_[indexPath.section] = newSection
            
            tableView.reloadSections(IndexSet([indexPath.section]), with: .automatic)
        default:
            break
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDataSource
    // -------------------------------------------------------------------------
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return sections_.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let section = sections_[section]
        
        return section.rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = sections_[indexPath.section]
        let row = section.rows[indexPath.row]
        
        return row.cell(for: indexPath, tableView: tableView)
    }
}
