//
//  QualificationPickerViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 03/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class QualificationPickerViewController: UITableViewController
{
    static let cellId = "QualificationPickerCellReuseId"
    
    fileprivate let allQualifications: [Qualification] = [ .student, .expert([]), .teacher([]) ]
    fileprivate var qualifications_: [Qualification] = []
    
    var pickedQualifications = [Qualification]() {
        didSet {
            // update questions
            let pickedQualificationNames = pickedQualifications.map { $0.name }
            
            qualifications_ = try! allQualifications.filter {
                (qualification) throws -> Bool in
                
                return !pickedQualificationNames.contains(qualification.name)
            }
            
            if isViewLoaded
            {
                tableView.reloadData()
            }
        }
    }
    
    weak var qualificationDelegate: QualificationPickerViewControllerDelegate? = nil
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDelegate
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let pickedQualification = qualifications_[indexPath.row]
        
        qualificationDelegate?.qualificationPickerViewController(self, didPickQualification: pickedQualification)
        
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
        return qualifications_.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: QualificationPickerViewController.cellId, for: indexPath)
        cell.textLabel?.text = qualifications_[indexPath.row].name
        return cell
    }
}
