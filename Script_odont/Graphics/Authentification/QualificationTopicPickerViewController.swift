//
//  QualificationTopicPickerViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 03/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class QualificationTopicPickerViewController: UITableViewController
{
    static let cellId = "QualificationTopicPickerCellReuseId"
    
    fileprivate var qualificationTopics_: [QualificationTopic] = []
    
    var pickedQualificationTopics = [QualificationTopic]() {
        didSet {
            // update questions
            
            qualificationTopics_ = try! QualificationTopic.allCases.filter {
                (qualificationTopic) throws -> Bool in
                
                return !pickedQualificationTopics.contains(qualificationTopic)
            }
            
            if isViewLoaded
            {
                tableView.reloadData()
            }
        }
    }
    
    weak var qualificationTopicDelegate: QualificationTopicPickerViewControllerDelegate? = nil
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDelegate
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let pickedQualificationTopic = qualificationTopics_[indexPath.row]
        
        qualificationTopicDelegate?.qualificationTopicPickerViewController(self, didPickQualificationTopic: pickedQualificationTopic)
        
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
        if qualificationTopics_.isEmpty
        {
            return 1
        }
        return qualificationTopics_.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: QualificationTopicPickerViewController.cellId, for: indexPath)
        if !qualificationTopics_.isEmpty
        {
            cell.textLabel?.textColor = Appearance.Color.default
            cell.textLabel?.text = qualificationTopics_[indexPath.row].name
        }
        else
        {
            cell.textLabel?.textColor = Appearance.Color.missing
            cell.textLabel?.text = "QualificationTopicPicker.NoTopicsRemaining".localized
        }
        return cell
    }
}
