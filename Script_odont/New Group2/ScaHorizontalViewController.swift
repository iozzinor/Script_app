//
//  ScaHorizontalViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

public class ScaHorizontalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    // -------------------------------------------------------------------------
    // MARK: - SECTIONS
    // -------------------------------------------------------------------------
    private enum ScaSection: Int, CaseIterable
    {
        case drawing
        case information
        
        func rows(for sca: Sca) -> [ScaRow]
        {
            switch self
            {
            case .drawing:
                var result: [ScaRow] = [ .wording ]
                result.append(contentsOf: Array<ScaRow>(repeating: .question, count: sca.questions.count))
                
                return result
            case .information:
                return Array<ScaRow>(repeating: .scale, count: 5)
            }
        }
        
        func allRows(for sca: Sca) -> [ScaRow] {
            return ScaSection.allCases.flatMap { $0.rows(for: sca) }
        }
        
        var title: String? {
            switch self
            {
            case .drawing:
                return nil
            case .information:
                return "Information"
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ROWS
    // -------------------------------------------------------------------------
    private enum ScaRow
    {
        case wording
        case question
        case scale
        
        func cell(for indexPath: IndexPath, tableView: UITableView, sca: Sca) -> UITableViewCell
        {
            switch self
            {
            case .wording:
                let cell = tableView.dequeueReusableCell(for: indexPath) as ScaHorizontalWordingCell
                cell.wordingLabel.text = sca.wording
                return cell
            case .question:
                let cell = tableView.dequeueReusableCell(for: indexPath) as ScaHorizontalQuestionCell
                cell.question = sca.questions[indexPath.row - 1]
                return cell
            case .scale:
                let cell = tableView.dequeueReusableCell(for: indexPath) as ScaHorizontalScaleCell
                
                let likertScale = sca.topic.likertScale
                cell.setScale(code: indexPath.row - 2, description: likertScale[indexPath.row - 2])
                return cell
            }
        }
    }
    
    @IBOutlet weak var progressItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    public var sca = Sca()
    
    fileprivate var currentQuestion_ = 0
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setup_()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setup_()
    {
        updateUi_()
        
        progressItem.isEnabled = false
        
        tableView.dataSource    = self
        tableView.delegate      = self
        
        // TEMP
        sca.wording = "Un patient de 34 ans se présente en consultation pour des douleurs intenses sur 36 depuis plusieurs jours. Cette dent a déjà été reconstitué par un onlay MOD 4 ans plus tôt."
        
        sca.questions.append(ScaQuestion(hypothesis: "une fracture amélo-dentinaire", newData:" un sondage parodontal de 8 mm en vestibulaire"))
        sca.questions.append(ScaQuestion(hypothesis: "une reprise carieuse et une pulpite sous l’onlay", newData:"  le test au froid est négatif"))
        sca.questions.append(ScaQuestion(hypothesis: "une reprise carieuse et à une pulpite sous l’onlay", newData:"    Il y a une douleur à la palpation et à la percussion de la dent"))
        sca.questions.append(ScaQuestion(hypothesis: "une surcharge occlusale", newData:"   le papier d’occlusion marque principalement sur les cuspides linguales"))
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UPDATE UI
    // -------------------------------------------------------------------------
    fileprivate func updateUi_()
    {
        updateProgress_()
    }
    
    fileprivate func updateProgress_()
    {
        progressItem.title = "Question \(currentQuestion_) out of \(sca.questions.count)"
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @IBAction func cancel(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - TABLE VIEW DELEGATE
    // -------------------------------------------------------------------------
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        return nil
    }
    
    // -------------------------------------------------------------------------
    // MARK: - TABLE VIEW DATA SOURCE
    // -------------------------------------------------------------------------
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return ScaSection.allCases.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return ScaSection.allCases[section].title
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let section = ScaSection.allCases[section]
        return section.rows(for: sca).count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = ScaSection.allCases[indexPath.section]
        let rows = section.rows(for: sca)
        let row = rows[indexPath.row]
        
        let cell = row.cell(for: indexPath, tableView: tableView, sca: sca)
        cell.accessoryType      = .none
        cell.selectionStyle     = .none
        return cell
    }
}
