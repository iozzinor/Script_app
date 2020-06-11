//
//  SequencePickerViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 01/06/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SequencePickerViewController: UITableViewController
{
    private static let reuseCellId = "SequenceNumberCellReuseId"
    
    var currentSequenceNumber: Int? = nil {
        didSet {
            tableView.reloadData()
        }
    }
    weak var delegate: SequencePickerDelegate? = nil
    
    fileprivate var previousSelectedCell_: UITableViewCell? = nil
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        delegate?.sequencePickerDidPick(self, sequenceNumber: currentSequenceNumber ?? 1)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        navigationItem.title = "SequencePicker.NavigationItem.Title".localized
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
        return TctQuestion.sequences.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell(style: .default, reuseIdentifier: SequencePickerViewController.reuseCellId)
        
        cell.textLabel?.text = "\(indexPath.row + 1)"
        
        if currentSequenceNumber != nil
        {
            cell.accessoryType = (currentSequenceNumber! == indexPath.row + 1 ? .checkmark : .none)
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
        
        currentSequenceNumber = indexPath.row + 1
        
       navigationController?.popViewController(animated: true)
    }
}
