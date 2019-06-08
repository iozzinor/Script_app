//
//  TctExportViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 08/06/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class TctExportViewController: UIViewController
{
    fileprivate static let alphabet_        = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    fileprivate static let defaultValue_    = 0
    
    var currentSequenceIndex = 0
    
    @IBOutlet weak var defaultButton: UIButton!
    @IBOutlet weak var panelButton: UIButton!
    @IBOutlet weak var respondentsButton: UIButton!
    
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
    }
    
    fileprivate func setupButtons_()
    {
        defaultButton.setTitle("TctExport.DefaultButton".localized, for: .normal)
        panelButton.setTitle("TctExport.PanelButton".localized, for: .normal)
        respondentsButton.setTitle("TctExport.RespondentsButton".localized, for: .normal)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @IBAction func displaySessions(_ sender: UIButton)
    {
        // group by category
        let allSessions = TctSaver.getSessions(forSequenceIndex: currentSequenceIndex)
        
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
    
    // -------------------------------------------------------------------------
    // MARK: - DISPLAY DEFAULT
    // -------------------------------------------------------------------------
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
                            return TctExportViewController.defaultValue_
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
                            currentAnswers.append(TctExportViewController.defaultValue_)
                        }
                    }
                }
                else
                {
                    currentAnswers = Array<Int>(repeating: TctExportViewController.defaultValue_, count: itemsCount)
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
        var indexLimit = TctExportViewController.alphabet_.count
        
        while index > indexLimit - 1
        {
            lettersCount    += 1
            indexLimit      += Constants.pow(TctExportViewController.alphabet_.count, lettersCount)
            workIndex       -= Constants.pow(TctExportViewController.alphabet_.count, lettersCount - 1)
        }
        
        var result = ""
        for i in 0..<lettersCount
        {
            let currentDivider = Constants.pow(TctExportViewController.alphabet_.count, lettersCount - i - 1)
            
            let currentLetterIndex = workIndex / currentDivider
            workIndex %= currentDivider
            
            let newLetterIndex = TctExportViewController.alphabet_.index(TctExportViewController.alphabet_.startIndex, offsetBy: currentLetterIndex)
            result += "\(TctExportViewController.alphabet_[newLetterIndex])"
        }
        return result
    }
}

