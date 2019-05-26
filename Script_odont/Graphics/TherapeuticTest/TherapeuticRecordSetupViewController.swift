//
//  TherapeuticRecordSetupViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 24/05/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

fileprivate func loadDefaultQuestions_() -> [TctQuestion]
{
    var result = [TctQuestion]()
    
    result.append(TctQuestion(volumeFileName: "14_1", wording: "Wording 1"))
    result.append(TctQuestion(volumeFileName: "14_2", wording: "Wording 2"))
    
    return result
}

class TherapeuticRecordSetupViewController: UITableViewController
{
    public static let toTherapeuticTestBasic        = "TherapeuticRecordSetupToTherapeuticTestBasicSegueId"
    public static let toParticipantCategoryPicker   = "TherapeuticRecordSetupToParticipantCategoryPickerSegueId"
    
    private static let detailCellId = "TherapeuticRecordSetupDetailCellReuseId"
    private static let basicCellId = "TherapeuticRecordSetupBasicCellReuseId"
    
    enum RecordSection: CaseIterable
    {
        case participant
        case launch
        
        var title: String? {
            switch self
            {
            case .participant:
                return "TherapeuticChoice.Section.Participant".localized
            case .launch:
                return nil
            }
        }
        
        var rows: [RecordRow] {
            switch self
            {
            case .participant:
                return [.participantName, .participantCategory]
            case .launch:
                return [.launch]
            }
        }
    }
    
    enum RecordRow
    {
        case participantName
        case participantCategory
        case launch
    }
    
    var selectionMode = TherapeuticTestBasicViewController.SelectionMode.single
    
    fileprivate var participantName_: String? = "default name"//= nil
    fileprivate var participantCategory_: ParticipantCategory? = ParticipantCategory.student4//= nil
    
    fileprivate var participantNameDoneAction_: UIAlertAction? = nil
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        navigationItem.title = "TherapeuticChoice.NavigationItem.Title".localized
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DATA SOURCE
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return RecordSection.allCases[section].title
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return RecordSection.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let currentSection = RecordSection.allCases[section]
        return currentSection.rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = RecordSection.allCases[indexPath.section]
        let row = section.rows[indexPath.row]
        
        switch row
        {
        case .participantName:
            let cell = tableView.dequeueReusableCell(withIdentifier: TherapeuticRecordSetupViewController.detailCellId, for: indexPath)
            
            cell.textLabel?.text = "Participant :"
            cell.detailTextLabel?.text = participantName_ ?? ""
            
            return cell
        case .participantCategory:
            let cell = tableView.dequeueReusableCell(withIdentifier: TherapeuticRecordSetupViewController.detailCellId, for: indexPath)
            
            cell.textLabel?.text = "TherapeuticChoice.Row.ParticipantCategory".localized
            cell.detailTextLabel?.text = participantCategory_?.name ?? "Common.None".localized
            
            return cell
        case .launch:
            let cell = tableView.dequeueReusableCell(withIdentifier: TherapeuticRecordSetupViewController.basicCellId, for: indexPath)
            cell.textLabel?.text = "TherapeuticChoice.Row.Launch".localized
            cell.textLabel?.textColor = canLaunchTest_() ? Appearance.Color.action : Appearance.Color.missing
            return cell
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DELEGATE
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let section = RecordSection.allCases[indexPath.section]
        let row = section.rows[indexPath.row]
        
        switch row
        {
        case .launch:
            if canLaunchTest_()
            {
                performSegue(withIdentifier: TherapeuticRecordSetupViewController.toTherapeuticTestBasic, sender: self)
            }
        case .participantName:
            displayParticipantNameDialog_()
        case .participantCategory:
            performSegue(withIdentifier: TherapeuticRecordSetupViewController.toParticipantCategoryPicker, sender: self)
        }
        
        tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UTILS
    // -------------------------------------------------------------------------
    fileprivate func displayParticipantNameDialog_()
    {
        let participantDialogController = UIAlertController(title: "TherapeuticChoice.ParticipantDialog.Title".localized, message: "TherapeuticChoice.ParticipantDialog.Message".localized, preferredStyle: .alert)
        
        let doneAction = UIAlertAction(title: "Common.Done".localized, style: .default, handler: {
            (action: UIAlertAction) -> Void in
            
            self.participantNameDoneAction_ = nil
            
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0), IndexPath(row: 0, section: 1)], with: .automatic)
            
        })
        doneAction.isEnabled = !(self.participantName_ ?? "").isEmpty
        self.participantNameDoneAction_ = doneAction
        
        participantDialogController.addAction(doneAction)
        participantDialogController.addTextField(configurationHandler: {
            textField -> Void in
            
            textField.placeholder   = "TherapeuticChoice.ParticipantDialog.Placeholder".localized
            textField.delegate      = self
            textField.text          = self.participantName_ ?? ""
        })
        
        present(participantDialogController, animated: true, completion: nil)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUES
    // -------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TherapeuticRecordSetupViewController.toTherapeuticTestBasic,
            let target = segue.destination as? TherapeuticTestBasicViewController
        {
            target.selectionMode = selectionMode
            target.questions = loadDefaultQuestions_()
        }
        else if segue.identifier == TherapeuticRecordSetupViewController.toParticipantCategoryPicker,
            let target = segue.destination as? ParticipantCategoryPickerViewController
        {
            target.currentCategory = participantCategory_
            target.delegate = self
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UTILS
    // -------------------------------------------------------------------------
    fileprivate func canLaunchTest_() -> Bool
    {
        return participantName_ != nil && participantCategory_ != nil
    }
}

// -----------------------------------------------------------------------------
// MARK: - UI TEXT FIELD DELEGATE
// -----------------------------------------------------------------------------
extension TherapeuticRecordSetupViewController: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard let currentString = textField.text else
        {
            return true
        }
        
        let start = currentString.index(currentString.startIndex, offsetBy: range.location)
        let end = currentString.index(currentString.startIndex, offsetBy: range.location + range.length)
        let newString = currentString.replacingCharacters(in: start..<end, with: string)
        
        participantNameDoneAction_?.isEnabled = !newString.isEmpty
        self.participantName_ = newString
        
        return true
    }
}

// -----------------------------------------------------------------------------
// MARK: - PARTICIPANT CATEGORY PICKER DELEGATE
// -----------------------------------------------------------------------------
extension TherapeuticRecordSetupViewController: ParticipantCategoryPickerDelegate
{
    func participantCategoryPicker(_ participantCategoryPickerViewController: ParticipantCategoryPickerViewController, didPickCategory participantCategory: ParticipantCategory?)
    {
        participantCategory_ = participantCategory
        
        tableView.reloadRows(at: [IndexPath(row: 1, section: 0), IndexPath(row: 0, section: 1)], with: .automatic)
    }
}
