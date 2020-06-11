//
//  MySctUnfinishedViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 09/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

fileprivate func image1_() -> Sct
{
    var sctQuestion = SctQuestion()
    // TEMP
    sctQuestion.type = .therapeutic
    sctQuestion.wording = "Un patient de 25 ans se présente en consultation suite à une chute en trotinette. Il souhaite reconstruire son incisive centrale."
    
    // volume
    sctQuestion.items.append(SctItem(hypothesis: "Cube", newData: SctData(content: .volume("simple_cube"))))
    sctQuestion.items.append(SctItem(hypothesis: "Sphère", newData: SctData(content: .volume("simple_sphere"))))
    sctQuestion.items.append(SctItem(hypothesis: "Dent maxillaire", newData: SctData(content: .volume("upper_jaw_scan"))))
    sctQuestion.items.append(SctItem(hypothesis: "Scan antagoniste", newData: SctData(content: .volume("antagonist"))))
    
    // image
    let hypothesis = "Réaliser une couronne céramo-céramique"
    let fracturePhoto = UIImage(named: "fracture_incisive_photo")!
    let fractureRadiography = UIImage(named: "fracture_incisive_radio")!
    sctQuestion.items.append(SctItem(hypothesis: hypothesis, newData: SctData(content: .image(fractureRadiography))))
    sctQuestion.items.append(SctItem(hypothesis: hypothesis, newData: SctData(image: fracturePhoto)))
    
    // text
    for i in 1..<4
    {
        sctQuestion.items.append(SctItem(hypothesis: "test hypothèse \(i)", newData: SctData(text: "test donnée \(i)")))
    }
    
    return Sct(questions: [sctQuestion])
}

fileprivate func defaultSctUnfinished_() -> SctUnfinished
{
    let statistics = SctStatistics(id: 0,
                                   meanScore: 10, meanDuration: 94, meanVotes: 4.3, launchesCount: 300, meanCompletionPercentage: 60, scoresDistribution: [])
    let information = SctLaunchInformation(type: .diagnostic, releaseDate: Date(), authorLastName: "Tartanpion", authorFirstName: "Jean", estimatedDuration: 34, questionsCount: 10, statistics: statistics)
    return SctUnfinished(session: SctSession(sct: Sct()),
                      answeredQuestions: 1,
                      duration: 30.0,
                      startDate: Date(),
                      lastDate: Date(),
                      information: information
            )
}

class SctUnfinishedViewController: SctDetailViewController
{
    static let toSctHorizontal = "SctUnfinishedToSctHorizontalSegueId"
    
    var sctUnfinished: SctUnfinished = defaultSctUnfinished_()
    {
        didSet {
            if isViewLoaded
            {
               super.reloadData()
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    let sections: [SctDetailViewController.SctDetailSection] = [.general, .lastSession, .duration, .popularity, .other]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        setupTableView(tableView)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUES
    // -------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == SctUnfinishedViewController.toSctHorizontal,
            let target = segue.destination as? SctHorizontalViewController
        {
            target.sctSession = SctSession(sct: image1_())
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - SCT DETAIL VIEW DELEGATE
// -----------------------------------------------------------------------------
extension SctUnfinishedViewController: SctDetailViewDelegate
{
    func sctDetailView(_ sctDetailViewController: SctDetailViewController, didPerformVote vote: Int)
    {
    }
    
    func sctDetailView(_ sctDetailViewController: SctDetailViewController, didUpdateVote vote: Int)
    {
    }
    
    func sctDetailView(didRemoveVote sctDetailViewController: SctDetailViewController)
    {
    }
    
    func sctDetailView(didResume sctDetailViewController: SctDetailViewController)
    {
        performSegue(withIdentifier: SctUnfinishedViewController.toSctHorizontal, sender: self)
    }
    
    func sctDetailView(didLaunch sctDetailViewController: SctDetailViewController)
    {
    }
}

// -----------------------------------------------------------------------------
// MARK: - SCT DETAIL VIEW DATA SOURCE
// -----------------------------------------------------------------------------
extension SctUnfinishedViewController: SctDetailViewDataSource
{
    func rows(for section: SctDetailViewController.SctDetailSection, at index: Int) -> [SctDetailViewController.SctDetailRow]
    {
        switch section
        {
        case .general:
            return [.type, .authorLastName, .authorFirstName, .meanScore, .questionsCount, .scoreDiagram]
        case .lastSession:
            return [.lastDate, .actualDuration, .answeredQuestionsCount]
        case .rate:
            return []
        case .results:
            return []
        case .duration:
            return [.estimatedDuration, .meanDuration]
        case .popularity:
            return [.votes, .launchesCount, .meanCompletionPercentage]
        case .other:
            return [.resume]
        }
    }
    
    var sct: Sct {
        return sctUnfinished.session.sct
    }
    
    var information: SctLaunchInformation {
        return sctUnfinished.information
    }
    
    var answeredQuestionsCount: Int {
        return sctUnfinished.answeredQuestions
    }
    
    var unfinished: SctUnfinished? {
        return sctUnfinished
    }
    
    var finished: SctFinished? {
        return nil
    }
}
