//
//  ParticipantCategoryPickerViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 24/05/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class ParticipantCategoryPickerViewController: UITableViewController
{
    private static let reuseCellId = "ParticipantCategoryCellReuseId"
    
    var currentCategory: ParticipantCategory? = nil {
        didSet {
            tableView.reloadData()
        }
    }
    weak var delegate: ParticipantCategoryPickerDelegate? = nil
    
    fileprivate var previousSelectedCell_: UITableViewCell? = nil
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        delegate?.participantCategoryPicker(self, didPickCategory: currentCategory)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        navigationItem.title = "ParticipantCategoryPicker.NavigationItem.Title".localized
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DATA SOURCE
    // -------------------------------------------------------------------------
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ParticipantCategory.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .default, reuseIdentifier: ParticipantCategoryPickerViewController.reuseCellId)
        let rowCategory = ParticipantCategory.allCases[indexPath.row]
        
        cell.textLabel?.text = rowCategory.name
        
        if currentCategory != nil
        {
            cell.accessoryType = (rowCategory == currentCategory! ? .checkmark : .none)
            previousSelectedCell_ = cell
        }
        else
        {
            cell.accessoryType = .none
        }
        return cell
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DELEGATE
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let newCell = tableView.cellForRow(at: indexPath) else
        {
            return
        }
        tableView.selectRow(at: nil, animated: false, scrollPosition: .none)
        
        previousSelectedCell_?.accessoryType = .none
        
        newCell.accessoryType = .checkmark
        previousSelectedCell_ = newCell
        
        currentCategory = ParticipantCategory.allCases[indexPath.row]
    }
}
