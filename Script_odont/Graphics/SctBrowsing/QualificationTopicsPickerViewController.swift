//
//  SctSearchCriteriaPickeViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 16/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class QualificationTopicsPickerViewController: UITableViewController
{
    static let qualificationTopicPickerCellId = "QualificationTopicPickerViewControllerCellReuseId"
    
    weak var delegate: QualificationTopicsPickerDelegate? = nil
    
    fileprivate var pickedTopics_ = Array<Bool>(repeating: false, count: QualificationTopic.allCases.count)
    
    fileprivate var uniqueTopicPicked_: Bool {
        return pickedTopics_.filter {
            $0
        }.count == 1
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        var topics = [QualificationTopic]()
        
        for (i, picked) in pickedTopics_.enumerated()
        {
            if picked
            {
                topics.append(QualificationTopic(rawValue: i)!)
            }
        }
        
        delegate?.qualificationTopicsPicker(self, didPickTopics: topics)
    }
    
    func setPickedTopics(_ topics: [QualificationTopic])
    {
        for topic in topics
        {
            pickedTopics_[topic.rawValue] = true
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDelegate
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        // can not unpick topic if it is the last one
        if uniqueTopicPicked_ && pickedTopics_[indexPath.row]
        {
            return nil
        }
        
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // toggle pick
        pickedTopics_[indexPath.row] = !pickedTopics_[indexPath.row]
        
        // update check mark
        if let cell = tableView.cellForRow(at: indexPath)
        {
            cell.accessoryType = (pickedTopics_[indexPath.row] ? .checkmark : .none)
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
        return SctSearchCriterion.all.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: QualificationTopicsPickerViewController.qualificationTopicPickerCellId, for: indexPath)
        
        cell.textLabel?.text = QualificationTopic.allCases[indexPath.row].name
        cell.accessoryType = (pickedTopics_[indexPath.row] ? .checkmark : .none)
        cell.selectionStyle = .none
        
        return cell
    }
}
