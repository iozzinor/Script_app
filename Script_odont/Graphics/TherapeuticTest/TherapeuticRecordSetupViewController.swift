//
//  TherapeuticRecordSetupViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 24/05/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class TherapeuticRecordSetupViewController: UITableViewController
{
    public static let toTherapeuticTestBasic        = "TherapeuticRecordSetupToTherapeuticTestBasicSegueId"
    public static let toParticipantCategoryPicker   = "TherapeuticRecordSetupToParticipantCategoryPickerSegueId"
    public static let toExerciseDurationPicker      = "TherapeuticRecordSetupToExerciseDurationPickerSegueId"
    public static let toSequencePicker              = "TherapeuticRecordSetupToSequencePickerSegueId"
    
    private static let detailCellId = "TherapeuticRecordSetupDetailCellReuseId"
    private static let basicCellId = "TherapeuticRecordSetupBasicCellReuseId"
    
    fileprivate enum RecordSection
    {
        case participant
        case sequence
        case launch
        case resume
        case finished
        
        var title: String? {
            switch self
            {
            case .participant:
                return "TherapeuticChoice.Section.Participant".localized
            case .sequence:
                return "TherapeuticChoice.Section.Sequence".localized
            case .resume:
                return "TherapeuticChoice.Section.Resume".localized
            case .finished:
                return "TherapeuticChoice.Section.Finished".localized
            case .launch:
                return nil
            }
        }
    }
    
    fileprivate enum RecordRow
    {
        case participantName
        case participantCategory
        case participantExerciseDuration
        
        case sequenceIndex
        
        case launch
        
        case resumeSession
    }
    
    fileprivate typealias Content = [(section: RecordSection, rows: [RecordRow])]
    
    var selectionMode = TherapeuticTestBasicViewController.SelectionMode.single
    
    fileprivate var participantName_: String? = "default name"//= nil
    fileprivate var participantCategory_: ParticipantCategory? = ParticipantCategory.student4//= nil
    fileprivate var participantExerciseDuration_: Int? = nil
    fileprivate var sequenceIndex_: Int = 0
    fileprivate var sessions_: [Bool: [TctSession]] = [:]
    
    fileprivate var participantNameDoneAction_: UIAlertAction? = nil
    
    fileprivate var sessionToResumeId_: Int? = nil

    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.registerNibCell(TctResumeSessionCell.self)
        loadSessions_(for: sequenceIndex_)
        updateTableContent_()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        navigationItem.title = "TherapeuticChoice.NavigationItem.Title".localized
        
        // reload sessions
        loadSessions_(for: sequenceIndex_)
        updateTableContent_()
        
        sessionToResumeId_ = nil
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DATA SOURCE
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return tableContent_[section].0.title
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return tableContent_.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let currentSection = tableContent_[section]
        return currentSection.1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = tableContent_[indexPath.section]
        let row = section.1[indexPath.row]
        
        switch row
        {
        case .participantName:
            let cell = tableView.dequeueReusableCell(withIdentifier: TherapeuticRecordSetupViewController.detailCellId, for: indexPath)
            
            cell.accessoryType = .none
            cell.textLabel?.text = "Participant :"
            cell.detailTextLabel?.text = participantName_ ?? ""
            
            return cell
        case .participantCategory:
            let cell = tableView.dequeueReusableCell(withIdentifier: TherapeuticRecordSetupViewController.detailCellId, for: indexPath)
            
            cell.accessoryType = .none
            cell.textLabel?.text = "TherapeuticChoice.Row.ParticipantCategory".localized
            cell.detailTextLabel?.text = participantCategory_?.name ?? "Common.None".localized
            
            return cell
        case .participantExerciseDuration:
            let cell = tableView.dequeueReusableCell(withIdentifier: TherapeuticRecordSetupViewController.detailCellId, for: indexPath)
            
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "TherapeuticChoice.Row.ParticipantExerciseDuration".localized
            cell.detailTextLabel?.text = String(participantExerciseDuration_ ?? 0)
            
            return cell
            
        case .sequenceIndex:
            let cell = tableView.dequeueReusableCell(withIdentifier: TherapeuticRecordSetupViewController.detailCellId, for: indexPath)
            
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.text = "TherapeuticChoice.Row.SequenceIndex".localized
            cell.detailTextLabel?.text = "\(sequenceIndex_ + 1)"
            
            return cell
            
        case .launch:
            let cell = tableView.dequeueReusableCell(withIdentifier: TherapeuticRecordSetupViewController.basicCellId, for: indexPath)
            cell.accessoryType = .none
            cell.textLabel?.text = "TherapeuticChoice.Row.Launch".localized
            cell.textLabel?.textColor = canLaunchTest_() ? Appearance.Color.action : Appearance.Color.missing
            return cell
            
        case .resumeSession:
            let cell = tableView.dequeueReusableCell(for: indexPath) as TctResumeSessionCell
            
            let session = sessions_[false]![indexPath.row]
            cell.accessoryType = .disclosureIndicator
            cell.sessionDateLabel.text = Constants.datetimeString(for: session.date)
            cell.sessionNumberLabel.text = "\(session.sequenceIndex + 1)"
            cell.sessionParticipantLabel.text = "\(session.participant.firstName.uppercased())"
            
            return cell
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DELEGATE
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let section = tableContent_[indexPath.section]
        let row = section.1[indexPath.row]
        
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
        case .participantExerciseDuration:
            performSegue(withIdentifier: TherapeuticRecordSetupViewController.toExerciseDurationPicker, sender: self)
        case .sequenceIndex:
            performSegue(withIdentifier: TherapeuticRecordSetupViewController.toSequencePicker, sender: self)
            
        case .resumeSession:
            let sessionToResume = sessions_[false]![indexPath.row]
            sessionToResumeId_ = sessionToResume.id
            performSegue(withIdentifier: TherapeuticRecordSetupViewController.toTherapeuticTestBasic, sender: self)
        }
        
        tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let section = tableContent_[indexPath.section]
        let row = section.1[indexPath.row]
        
        switch row
        {
        case .launch, .participantName, .participantCategory, .participantExerciseDuration, .sequenceIndex:
            return nil
            
        case .resumeSession:
            return UISwipeActionsConfiguration(actions: [UIContextualAction(style: .destructive, title: "Common.Delete".localized, handler: { (_, _, completion) in
                
                let session = self.sessions_[false]![indexPath.row]
                
                self.confirmSessionDeletion_(session: session, completion: completion)
            })]
            )
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - TABLE CONTENT
    // -------------------------------------------------------------------------
    fileprivate var tableContent_ = Content()
    
    fileprivate func updateTableContent_()
    {
        var result = Content()
        
        // participant
        var participantRows: [RecordRow] = [.participantName, .participantCategory]
        if let category = participantCategory_
        {
            switch category
            {
            case .teacher:
                participantRows.append(.participantExerciseDuration)
            case .intern, .student4, .student5, .student6:
                break
            }
        }
        result.append((.participant, participantRows))
        
        // sequence
        result.append((.sequence, [.sequenceIndex]))
        
        // launch
        result.append((.launch, [.launch]))
        
        // incomplete
        if let incompleteSessions = sessions_[false],
            !incompleteSessions.isEmpty
        {
            result.append((.resume, Array<RecordRow>(repeating: .resumeSession, count: incompleteSessions.count)))
        }
        
        tableContent_ = result
        
        tableView.reloadData()
    }
    
    fileprivate func indexPath_(for recordRow: RecordRow) -> IndexPath
    {
        for (sectionIndex, sectionContent) in tableContent_.enumerated()
        {
            let rows = sectionContent.1
            
            if let rowIndex = rows.index(of: recordRow)
            {
                return IndexPath(row: rowIndex, section: sectionIndex)
            }
        }
        return IndexPath(row: 0, section: 0)
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
            
            self.tableView.reloadRows(at: [self.indexPath_(for: .participantName), self.indexPath_(for: .launch)], with: .automatic)
            
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
    
    fileprivate func canLaunchTest_() -> Bool
    {
        return participantName_ != nil && participantCategory_ != nil
    }
    
    fileprivate func loadSessions_(for sequenceIndex: Int)
    {
        // sessions dictionary key = whether the session is complete
        sessions_ = [:]
        sessions_[true] = []
        sessions_[false] = []
        
        let allSessions = TctSaver.getAllSession()
        for session in allSessions
        {
            let isSessionComplete = isSessionComplete_(session: session)
            sessions_[isSessionComplete]!.append(session)
        }
        
        // sort
        let sessionSorter: (TctSession, TctSession) -> Bool = {
            (a, b) -> Bool in
            
            if a.sequenceIndex == b.sequenceIndex
            {
                return a.id > b.id
            }
            return a.sequenceIndex < b.sequenceIndex
        }
        
        sessions_[true]!.sort(by: sessionSorter)
        sessions_[false]!.sort(by: sessionSorter)
    }
    
    fileprivate func isSessionComplete_(session: TctSession) -> Bool
    {
        for questionAnswers in session.answers
        {
            var isQuestionComplete = false
            
            for answer in questionAnswers
            {
                if answer > -1
                {
                    isQuestionComplete = true
                    break
                }
            }
            
            if !isQuestionComplete
            {
                return false
            }
        }
        return true
    }
    
    fileprivate func confirmSessionDeletion_(session: TctSession, completion: @escaping (Bool) -> Void)
    {
        let confirmController = UIAlertController(title: "TherapeuticChoice.SessionDeletionDialog.Title".localized, message: "TherapeuticChoice.SessionDeletionDialog.Message".localized, preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "Common.No".localized, style: .default, handler:  {
            (_) -> Void in
            completion(false)
        })
        let yesAction = UIAlertAction(title: "Common.Yes".localized, style: .destructive, handler: {
            (_) -> Void in
            
            TctSaver.delete(for: session.sequenceIndex, id: session.id)
            
            completion(true)
        })
        
        confirmController.addAction(noAction)
        confirmController.addAction(yesAction)
        
        present(confirmController, animated: true, completion: nil)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUES
    // -------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // test basic
        if segue.identifier == TherapeuticRecordSetupViewController.toTherapeuticTestBasic,
            let target = segue.destination as? TherapeuticTestBasicViewController
        {
            target.selectionMode = selectionMode
            target.sequenceIndex = sequenceIndex_
            target.participant = TctParticipant(firstName: participantName_!, category: participantCategory_!)
            
            // resume session
            if let sessionId = sessionToResumeId_
            {
                target.loadSession(withId: sessionId)
            }
        }
        // participant category
        else if segue.identifier == TherapeuticRecordSetupViewController.toParticipantCategoryPicker,
            let target = segue.destination as? ParticipantCategoryPickerViewController
        {
            target.currentCategory = participantCategory_
            target.delegate = self
        }
        // exercise duration picker
        else if segue.identifier == TherapeuticRecordSetupViewController.toExerciseDurationPicker,
            let target = segue.destination as? ExerciseDurationViewController
        {
            target.delegate = self
            if let duration = participantExerciseDuration_
            {
                target.exerciseDuration = duration
            }
        }
        // sequence picker
        else if segue.identifier == TherapeuticRecordSetupViewController.toSequencePicker,
            let target = segue.destination as? SequencePickerViewController
        {
            target.currentSequenceNumber = sequenceIndex_ + 1
            target.delegate = self
        }
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
        updateTableContent_()
    }
}

// -----------------------------------------------------------------------------
// MARK: - EXERCISE DURATION PICKER DELEGATE
// -----------------------------------------------------------------------------
extension TherapeuticRecordSetupViewController: ExerciseDurationPickerDelegate
{
    func exerciseDurationPickerViewController(_ exerciseDurationPickerViewController: ExerciseDurationViewController, didPickExerciseDuration exerciseDuration: Int)
    {
        participantExerciseDuration_ = exerciseDuration
    }
}

// -----------------------------------------------------------------------------
// MARK: - SEQUENCE PICKER DELEGATE
// -----------------------------------------------------------------------------
extension TherapeuticRecordSetupViewController: SequencePickerDelegate
{
    func sequencePickerDidPick(_ sequencePickerViewController: SequencePickerViewController, sequenceNumber: Int)
    {
        // reload sequence row
        sequenceIndex_ = sequenceNumber - 1
        tableView.reloadRows(at: [indexPath_(for: .sequenceIndex)], with: .automatic)
    }
}
