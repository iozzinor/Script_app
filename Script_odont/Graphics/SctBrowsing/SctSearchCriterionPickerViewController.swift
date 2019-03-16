//
//  SctSearchCriterionPickerViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 16/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SctSearchCriterionPickerViewController: UITableViewController
{
    static let searchCriterionPickerCellId = "SctSearchCriterionPickerCellReuseId"
    
    weak var delegate: SctSearchCriterionPickerDelegate? = nil
    
    fileprivate var pickableCriteria_ = SctSearchCriterion.all
    fileprivate var pickedCriterionIndex_ = 0
    
    func setPickedCriteria(_ pickedCriteria: [SctSearchCriterion])
    {
        pickableCriteria_ = SctSearchCriterion.pickableCriteria(alreadyPicked: pickedCriteria)
        pickedCriterionIndex_ = 0
        tableView.reloadData()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationItem.title = "SctSearchCriterionPicker.NavigationItem.Title".localized
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @IBAction func cancel(_ sender: UIBarButtonItem)
    {
        delegate?.sctSearchCriterionPicker(didCancelPick: self)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem)
    {
        delegate?.sctSearchCriterionPicker(self, didPickCriterion: pickableCriteria_[pickedCriterionIndex_])
        dismiss(animated: true, completion: nil)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDelegate
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let previousCell = tableView.cellForRow(at: IndexPath(row: pickedCriterionIndex_, section: 0))
        {
            previousCell.accessoryType = .none
        }
        
        pickedCriterionIndex_ = indexPath.row
        if let newCell = tableView.cellForRow(at: IndexPath(row: pickedCriterionIndex_, section: 0))
        {
            newCell.accessoryType = .checkmark
        }
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
        return pickableCriteria_.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: SctSearchCriterionPickerViewController.searchCriterionPickerCellId, for: indexPath)
        
        let criterion = pickableCriteria_[indexPath.row]
        
        cell.textLabel?.text = criterion.name
        cell.accessoryType = (indexPath.row == pickedCriterionIndex_ ? .checkmark : .none)
        cell.selectionStyle = .none
        
        return cell
    }
}
