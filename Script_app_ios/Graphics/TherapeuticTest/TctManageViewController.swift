//
//  TctManageViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/05/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class TctManageViewController: UIViewController
{
    public static let toSequencePicker  = "TctManageToSequencePickerSegueId"
    public static let toTctExport       = "TctManageToTctExportSegueId"
    
    @IBOutlet weak var sequenceButton: UIButton!
    @IBOutlet weak var sessionsCountLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var exportButton: UIButton!
    
    fileprivate var currentSequenceIndex_ = 0
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setup_()
    }
    
    fileprivate func setup_()
    {
        setupButtons_()
        
        updateSequenceButton()
        updateSessionsCountLabel_()
        updateDeleteButton_()
    }
    
    fileprivate func setupButtons_()
    {
        deleteButton.setTitle("TctManage.DeleteButton".localized, for: .normal)
        exportButton.setTitle("TctManage.ExportButton".localized, for: .normal)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UPDATE
    // -------------------------------------------------------------------------
    fileprivate func updateSequenceButton()
    {
        sequenceButton.setTitle("TherapeuticChoice.Row.SequenceIndex".localized + " \(currentSequenceIndex_ + 1)", for: .normal)
    }
    
    fileprivate func updateSessionsCountLabel_()
    {
        let format = "TctManage.SessionsCount".localized
        sessionsCountLabel.text = String.localizedStringWithFormat(format, TctSaver.getSessionsCount(forSequenceIndex: currentSequenceIndex_))
    }
    
    fileprivate func updateDeleteButton_()
    {
        deleteButton.isEnabled = TctSaver.getSessionsCount(forSequenceIndex: currentSequenceIndex_) > 0
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @IBAction func selectSequence(_ sender: UIButton)
    {
        performSegue(withIdentifier: TctManageViewController.toSequencePicker, sender: self)
    }
    
    @IBAction func deleteAll(_ sender: UIButton)
    {
        TctSaver.deleteAll()
        updateSessionsCountLabel_()
        updateDeleteButton_()
    }
    
    @IBAction func export(_ sender: UIButton)
    {
        performSegue(withIdentifier: TctManageViewController.toTctExport, sender: self)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUE
    // -------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == TctManageViewController.toSequencePicker,
            let target = segue.destination as? SequencePickerViewController
        {
            target.delegate = self
            target.currentSequenceNumber = currentSequenceIndex_ + 1
        }
        else if segue.identifier == TctManageViewController.toTctExport,
            let target = segue.destination as? TctExportViewController
        {
            target.currentSequenceIndex = currentSequenceIndex_
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - SEQUENCE PICKER DELEGATE
// -----------------------------------------------------------------------------
extension TctManageViewController: SequencePickerDelegate
{
    func sequencePickerDidPick(_ sequencePickerViewController: SequencePickerViewController, sequenceNumber: Int)
    {
        currentSequenceIndex_ = sequenceNumber - 1
        
        updateSequenceButton()
        updateSessionsCountLabel_()
        updateDeleteButton_()
    }
}
