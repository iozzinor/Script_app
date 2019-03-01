//
//  GoToSca.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class GoToScaViewController: UITableViewController
{
    var session = ScaSession(exam: ScaExam(scas: [])) {
        didSet {
            if isViewLoaded
            {
                tableView.reloadData()
            }
        }
    }
    var currentSca = -1  {
        didSet {
            if isViewLoaded
            {
                tableView.reloadData()
            }
        }
    }
    
    weak var delegate: GoToScaViewControllerDelegate? = nil
    
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
        delegate?.goToScaViewControllerDidCancel(self)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem)
    {
        delegate?.goToScaViewController(self, didChooseSca: currentSca)
        dismiss(animated: true, completion: nil)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDelegate
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let previousIndex = IndexPath(row: currentSca, section: 0)
        currentSca = indexPath.row
        
        let previousCell = tableView.cellForRow(at: previousIndex)
        previousCell?.accessoryType = .none
        
        let currentCell = tableView.cellForRow(at: indexPath)
        currentCell?.accessoryType = .checkmark
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
        return session.exam.scas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(for: indexPath) as GoToScaCell
        
        let sca = session.exam.scas[indexPath.row]
            
        cell.accessoryType = (indexPath.row == currentSca ? .checkmark : .none)
        cell.setSca(indexPath.row, wording: sca.wording, isValid: session.isScaValid(indexPath.row))
        
        return cell
    }
}
