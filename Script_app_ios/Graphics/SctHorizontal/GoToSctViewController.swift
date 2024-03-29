//
//  GoToSct.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class GoToSctViewController: UITableViewController
{
    var session = SctSession(sct: Sct(questions: [])) {
        didSet {
            if isViewLoaded
            {
                tableView.reloadData()
            }
        }
    }
    var currentSct = -1  {
        didSet {
            if isViewLoaded
            {
                tableView.reloadData()
            }
        }
    }
    
    weak var delegate: GoToSctViewControllerDelegate? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.reloadData()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @IBAction func cancel(_ sender: UIBarButtonItem)
    {
        delegate?.goToSctViewControllerDidCancel(self)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem)
    {
        delegate?.goToSctViewController(self, didChooseSct: currentSct)
        dismiss(animated: true, completion: nil)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DELEGATE
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let previousIndex = IndexPath(row: currentSct, section: 0)
        currentSct = indexPath.row
        
        let previousCell = tableView.cellForRow(at: previousIndex)
        previousCell?.accessoryType = .none
        
        let currentCell = tableView.cellForRow(at: indexPath)
        currentCell?.accessoryType = .checkmark
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
        return session.sct.questions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(for: indexPath) as GoToSctCell
        
        let sct = session.sct.questions[indexPath.row]
            
        cell.accessoryType = (indexPath.row == currentSct ? .checkmark : .none)
        cell.setSct(indexPath.row, wording: sct.wording, isValid: session.isQuestionValid(indexPath.row))
        
        return cell
    }
}
