//
//  OtherViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 01/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class OtherViewController: UITableViewController
{
    static let toWalkthroughs           = "OtherToWalkthroughsSegueId"
    static let toLeaderboard            = "OtherToLeaderboardSegueId"
    static let toToothRecognition       = "OtherToToothRecognitionSegueId"
    static let toTherapeuticTestBasic   = "OtherToTherapeuticTestBasicSegueId"
    static let toTherapeuticTestScale   = "OtherToTherapeuticTestScaleSegueId"
    
    static let otherCellIdentifier = "OtherCellReuseId"
    
    // -------------------------------------------------------------------------
    // MARK: - ROWS
    // -------------------------------------------------------------------------
    enum OtherRow: Int, CaseIterable
    {
        case walkthroughs
        case leaderboard
        case toothRecognition
        case therapeuticTestBasic
        case therapeuticTestScale
        
        var title: String {
            switch self
            {
            case .walkthroughs:
                return "OtherViewController.Tutorials".localized
            case .leaderboard:
                return "OtherViewController.Leaderboard".localized
            case .toothRecognition:
                return "OtherViewController.ToothRecognition".localized
            case .therapeuticTestBasic:
                return "Therapeutic Test Basic!"
            case .therapeuticTestScale:
                return "Therapeutic Test Scale!"
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        navigationItem.title = "OtherViewController.NavigationItem.Title".localized
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUES
    // -------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == OtherViewController.toTherapeuticTestScale,
            let target = segue.destination as? TherapeuticTestBasicViewController
        {
            target.selectionMode = .scale(TherapeuticTestBasicViewController.diagnosticScale)
            target.xRay = UIImage(named: "fracture_incisive_radio")
            
            target.stlToothUrl = Bundle.main.url(forResource: "14_1", withExtension: "stl", subdirectory: "ToothRecognition")
        }
        else if segue.identifier == OtherViewController.toTherapeuticTestBasic,
            let target = segue.destination as? TherapeuticTestBasicViewController
        {
            target.xRay = UIImage(named: "fracture_incisive_photo")
            
            target.stlToothUrl = Bundle.main.url(forResource: "14_2", withExtension: "stl", subdirectory: "ToothRecognition")
        }
    }
    
    fileprivate func displayWalkthroughs_()
    {
        performSegue(withIdentifier: OtherViewController.toWalkthroughs, sender: self)
    }
    
    fileprivate func displayLeaderboard_()
    {
        performSegue(withIdentifier: OtherViewController.toLeaderboard, sender: self)
    }
    
    fileprivate func displayToothRecognition_()
    {
        performSegue(withIdentifier: OtherViewController.toToothRecognition, sender: self)
    }
    
    fileprivate func displayTherapeuticTestBasic()
    {
        performSegue(withIdentifier: OtherViewController.toTherapeuticTestBasic, sender: self)
    }
    
    fileprivate func displayTherapeuticTestScale()
    {
        performSegue(withIdentifier: OtherViewController.toTherapeuticTestScale, sender: self)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DELEGATE
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let row = OtherRow.allCases[indexPath.row]
        
        switch row
        {
        case .leaderboard:
            displayLeaderboard_()
        case .walkthroughs:
            displayWalkthroughs_()
        case .toothRecognition:
            displayToothRecognition_()
        case .therapeuticTestBasic:
            displayTherapeuticTestBasic()
        case .therapeuticTestScale:
            displayTherapeuticTestScale()
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DATA SOURCE
    // -------------------------------------------------------------------------
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return OtherRow.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: OtherViewController.otherCellIdentifier, for: indexPath)
        let row = OtherRow.allCases[indexPath.row]
        
        cell.accessoryType = .none
        cell.textLabel?.text = row.title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
