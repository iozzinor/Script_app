//
//  TctExportViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 08/06/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

// -----------------------------------------------------------------------------
// DEFAULT EXPORT
// -----------------------------------------------------------------------------
fileprivate func exportDefault_(categorySessions: [ParticipantCategory: [TctSession]], allSessions: [TctSession]) -> String
{
    var result = ""
    
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
    result += headerTitles.join(",")
    
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
        getDefaultQuestion_(categorySessions: categorySessions, index: i, linesCount: &linesCount, result: &result)
    }
    
    return result
}

fileprivate func getDefaultQuestion_(categorySessions: [ParticipantCategory: [TctSession]], index: Int, linesCount: inout Int, result: inout String)
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
        let startColumn = TctExporter.columnName(index: columnIndex)
        let endColumn = TctExporter.columnName(index: endColumnIndex)
        for i in 0..<itemsCount
        {
            elementsToPrint[i].append("=MOYENNE(\(startColumn)\(linesCount + i):\(endColumn)\(linesCount + i))")
        }
        columnIndex = endColumnIndex + 2
    }
    
    for elements in elementsToPrint
    {
        result += elements.join(",") + "\n"
    }
    
    linesCount += itemsCount
}

// -----------------------------------------------------------------------------
// RESPONDENT EXPORT
// -----------------------------------------------------------------------------
fileprivate func exportRespondent_(categorySessions: [ParticipantCategory: [TctSession]], allSessions: [TctSession]) -> String
{
    // remove experts
    if categorySessions.keys.contains(.teacher)
    {
        var newCategorySessions = categorySessions
        newCategorySessions.removeValue(forKey: .teacher)
        
        return exportRespondent_(categorySessions: newCategorySessions, allSessions: allSessions.filter {
            $0.participant.category != .teacher
        })
    }
    
    var result = ""
    
    appendResponses_(categorySessions: categorySessions, allSessions: allSessions, result: &result)
    
    return result
}

// -----------------------------------------------------------------------------
// PANEL EXPORT
// -----------------------------------------------------------------------------
fileprivate func exportPanel_(categorySessions: [ParticipantCategory: [TctSession]], allSessions: [TctSession]) -> String
{
    // remove students
    var newCategorySessions = categorySessions
    
    for key in ParticipantCategory.allCases
    {
        if key == .teacher
        {
            continue
        }
        if newCategorySessions.keys.contains(key)
        {
            newCategorySessions.removeValue(forKey: key)
        }
    }
    
    var result = ""
    
    appendResponses_(categorySessions: newCategorySessions, allSessions: allSessions.filter {
        $0.participant.category == .teacher
    }, result: &result)
    
    return result
}

// -----------------------------------------------------------------------------
// RESPONSE UTILITY
// -----------------------------------------------------------------------------
fileprivate func appendResponses_(categorySessions: [ParticipantCategory: [TctSession]], allSessions: [TctSession], result: inout String)
{
    // get items count
    var itemsCount = 0
    for session in allSessions
    {
        for index in 0..<session.answers.count
        {
            if itemsCount < session.answers[index].count
            {
                itemsCount = session.answers[index].count
            }
        }
    }
    
    // get answers count
    var questionsCount = 0
    for session in allSessions
    {
        if questionsCount < session.answers.count
        {
            questionsCount = session.answers.count
        }
    }
    
    // print answers
    // question items in column
    // students in row
    var valuesToDisplay = Array<Array<String>>(repeating: [], count: allSessions.count)
    var currentRow = 0
    
    for (_, sessions) in categorySessions
    {
        for session in sessions
        {
            for i in 0..<questionsCount
            {
                var newAnswers = [Int]()
                if i < session.answers.count
                {
                    newAnswers = session.answers[i]
                }
                else
                {
                    newAnswers = Array<Int>(repeating: 0, count: itemsCount)
                }
                
                if newAnswers.count > itemsCount
                {
                    newAnswers.removeLast(newAnswers.count - itemsCount)
                }
                else
                {
                    for _ in 0..<(itemsCount - newAnswers.count)
                    {
                        newAnswers.append(0)
                    }
                }
                
                let newValues = newAnswers.map { (value) -> Int in
                    return value + 1
                }
                
                valuesToDisplay[currentRow].append(contentsOf: newValues.map { String($0) })
            }
            
            currentRow += 1
        }
    }
    
    for (i, values) in valuesToDisplay.enumerated()
    {
        result += values.join("\t")
        if i < valuesToDisplay.count - 1
        {
            result += "\n"
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - DIFFUSER
// -----------------------------------------------------------------------------
fileprivate protocol Diffuser
{
    func diffuse(exportedTct: String)
}

fileprivate class ConsoleDiffuser: Diffuser
{
    func diffuse(exportedTct: String)
    {
        print(exportedTct)
    }
}

fileprivate class HttpDiffuser: Diffuser
{
    var host = Host(name: "localhost", port: 80)
    private var ephemeralSession_ = URLSession(configuration: .ephemeral)
    
    func diffuse(exportedTct: String)
    {
        guard let url = URL(string: "http://\(host.name):\(host.port)") else
        {
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/x-www-urlencoded-form", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let postContent = "content=\(exportedTct)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryValueAllowed) ?? ""
        request.httpBody = postContent.data(using: .utf8)
        
        let task = ephemeralSession_.dataTask(with: request) {
            data, response, error -> Void in
        }
        task.resume()
    }
}

class TctExportViewController: UIViewController
{
    fileprivate static let alphabet_        = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    fileprivate static let defaultValue_    = 0
    
    var currentSequenceIndex = 0
    
    @IBOutlet weak var hostNameField: UITextField!
    @IBOutlet weak var hostPortField: UITextField!
    @IBOutlet weak var defaultButton: UIButton!
    @IBOutlet weak var panelButton: UIButton!
    @IBOutlet weak var respondentsButton: UIButton!
    
    fileprivate var defaultExporter_        = TctExporter(exporter: exportDefault_)
    fileprivate var respondentsExporter_    = TctExporter(exporter: exportRespondent_)
    fileprivate var panelExporter_          = TctExporter(exporter: exportPanel_)
    
    fileprivate var diffuser_: Diffuser!
    fileprivate var httpDiffuser_: HttpDiffuser? {
        return diffuser_ as? HttpDiffuser
    }
    
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
        setupHostFields()
        setupButtons_()
        setupTouchRecognizer_()
        
        diffuser_ = HttpDiffuser()
    }
    
    fileprivate func setupHostFields()
    {
        hostNameField.delegate = self
        hostPortField.delegate = self
    }
    
    fileprivate func setupButtons_()
    {
        defaultButton.setTitle("TctExport.DefaultButton".localized, for: .normal)
        panelButton.setTitle("TctExport.PanelButton".localized, for: .normal)
        respondentsButton.setTitle("TctExport.RespondentsButton".localized, for: .normal)
    }
    
    fileprivate func setupTouchRecognizer_()
    {
        let touchRecognizer = UITapGestureRecognizer(target: self, action: #selector(TctExportViewController.dismissKeyboard_))
        view.addGestureRecognizer(touchRecognizer)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @IBAction func displaySessions(_ sender: UIButton)
    {
        diffuser_.diffuse(exportedTct: defaultExporter_.export(sequenceIndex: currentSequenceIndex))
    }
    
    @IBAction func displayPanel(_ sender: UIButton)
    {
        diffuser_.diffuse(exportedTct: panelExporter_.export(sequenceIndex: currentSequenceIndex))
    }
    
    @IBAction func displayRespondents(_ sender: UIButton)
    {
        diffuser_.diffuse(exportedTct: respondentsExporter_.export(sequenceIndex: currentSequenceIndex))
    }
    
    @objc fileprivate func dismissKeyboard_()
    {
        view.endEditing(true)
    }
}

// -----------------------------------------------------------------------------
// MARK: - UI TEXT FIELD DELEGATE
// -----------------------------------------------------------------------------
extension TctExportViewController: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard let currentString = textField.text else
        {
            return false
        }
        
        let start = currentString.index(currentString.startIndex, offsetBy: range.location)
        let end = currentString.index(currentString.startIndex, offsetBy: range.location + range.length)
        
        let newString = currentString.replacingCharacters(in: start..<end, with: string)
        
        if textField == self.hostNameField
        {
            httpDiffuser_?.host.name = newString
            
            return true
        }
        // host port field
        else if textField == self.hostPortField
        {
            if newString.isEmpty
            {
                httpDiffuser_?.host.port = 80
                return true
            }
            
            if let newPort = Int(newString)
            {
                httpDiffuser_?.host.port = newPort
                return true
            }
            return false
        }
        
        return true
    }
}
