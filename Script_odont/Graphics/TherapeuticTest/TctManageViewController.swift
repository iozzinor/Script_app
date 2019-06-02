//
//  TctManageViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/05/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

fileprivate func pow_(_ number: Int, _ exponent: Int) -> Int
{
    if exponent < 0
    {
        return 0
    }
    else if exponent == 0
    {
        return 1
    }
    else if exponent == 1 || number == 1 || number == 0
    {
        return number
    }
    
    let result = pow_(number, exponent / 2)
    if exponent & 1 == 0
    {
        return result * result
    }
    return number * result * result
}

class TctManageViewController: UIViewController
{
    public static let toSequencePicker = "TctManageToSequencePickerSegueId"
    
    fileprivate static let alphabet_        = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    fileprivate static let defaultValue_    = 0
    
    @IBOutlet weak var sequenceButton: UIButton!
    @IBOutlet weak var sessionsCountLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var displayButton: UIButton!
    
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
        displayButton.setTitle("TctManage.DisplayButton".localized, for: .normal)
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
    
    @IBAction func displaySessions(_ sender: UIButton)
    {
        // group by category
        let allSessions = TctSaver.getSessions(forSequenceIndex: currentSequenceIndex_)
        
        var categorySessions = [ParticipantCategory: [TctSession]]()
        for session in allSessions
        {
            if !categorySessions.keys.contains(session.participant.category)
            {
                categorySessions[session.participant.category] = []
            }
            
            categorySessions[session.participant.category]!.append(session)
        }
        
        // header
        var headerTitles = ["Questions", "Items"]
        for (category, sessions) in categorySessions
        {
            for i in 0..<sessions.count
            {
                headerTitles.append("\(category.name) \(i + 1)")
            }
            headerTitles.append("Moyenne \(category.name)")
        }
        print(headerTitles.join(","))
        
        // get answers count
        var questionsCount = 0
        for session in allSessions
        {
            if questionsCount < session.answers.count
            {
                questionsCount = session.answers.count
            }
        }
        
        // print questions
        var linesCount = 2
        for i in 0..<questionsCount
        {
            printQuestion_(categorySessions: categorySessions, index: i, linesCount: &linesCount)
        }
    }
    
    fileprivate func printQuestion_(categorySessions: [ParticipantCategory: [TctSession]], index: Int, linesCount: inout Int)
    {
        // get items count
        var itemsCount = 0
        for (_, sessions) in categorySessions
        {
            for session in sessions
            {
                if session.answers.count > index
                {
                    if itemsCount < session.answers[index].count
                    {
                        itemsCount = session.answers[index].count
                    }
                }
            }
        }
        
        // print question
        var elementsToPrint = Array<Array<String>>(repeating: [], count: itemsCount)
        for i in 0..<itemsCount
        {
            // question index
            if i == 0
            {
                elementsToPrint[i].append("\(index + 1)")
            }
            else
            {
                 elementsToPrint[i].append("")
            }
            
            // item index
            elementsToPrint[i].append("\(i + 1)")
        }
        var columnIndex = 2
        for (_, sessions) in categorySessions
        {
            for session in sessions
            {
                var currentAnswers: [Int]
                if session.answers.count > index
                {
                    currentAnswers = session.answers[index].map {
                        if $0 < 0
                        {
                            return TctManageViewController.defaultValue_
                        }
                        if $0 < 2
                        {
                            return $0 - 2
                        }
                        return $0 - 1
                    }
                    if currentAnswers.count > itemsCount
                    {
                        currentAnswers.removeLast(currentAnswers.count - itemsCount)
                    }
                    else
                    {
                        for _ in 0..<(itemsCount - currentAnswers.count)
                        {
                            currentAnswers.append(TctManageViewController.defaultValue_)
                        }
                    }
                }
                else
                {
                    currentAnswers = Array<Int>(repeating: TctManageViewController.defaultValue_, count: itemsCount)
                }
                
                for (i, currentAnswer) in currentAnswers.enumerated()
                {
                    elementsToPrint[i].append("\(currentAnswer)")
                }
            }
            
            // means
            let endColumnIndex = columnIndex + sessions.count - 1
            let startColumn = columnName_(index: columnIndex)
            let endColumn = columnName_(index: endColumnIndex)
            for i in 0..<itemsCount
            {
                elementsToPrint[i].append("=MOYENNE(\(startColumn)\(linesCount + i):\(endColumn)\(linesCount + i))")
            }
            columnIndex = endColumnIndex + 2
        }
        
        for elements in elementsToPrint
        {
            print(elements.join(","))
        }
        
        linesCount += itemsCount
    }
    
    /// The index starts from 0
    fileprivate func columnName_(index: Int) -> String
    {
        if index < 0
        {
            return ""
        }
        else if index == 0
        {
            return "A"
        }
        
        // get the number of letters
        var lettersCount = 1
        var workIndex = index
        var indexLimit = TctManageViewController.alphabet_.count
        
        while index > indexLimit - 1
        {
            lettersCount    += 1
            indexLimit      += pow_(TctManageViewController.alphabet_.count, lettersCount)
            workIndex       -= pow_(TctManageViewController.alphabet_.count, lettersCount - 1)
        }
        
        var result = ""
        for i in 0..<lettersCount
        {
            let currentDivider = pow_(TctManageViewController.alphabet_.count, lettersCount - i - 1)
            
            let currentLetterIndex = workIndex / currentDivider
            workIndex %= currentDivider
            
            let newLetterIndex = TctManageViewController.alphabet_.index(TctManageViewController.alphabet_.startIndex, offsetBy: currentLetterIndex)
            result += "\(TctManageViewController.alphabet_[newLetterIndex])"
        }
        return result
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
