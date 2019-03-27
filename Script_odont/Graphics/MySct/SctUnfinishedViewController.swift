//
//  MySctUnfinishedViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 09/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

fileprivate func imageExam1_() -> SctExam
{
    var sct = Sct()
    // TEMP
    sct.topic = .therapeutic
    sct.wording = "Un patient de 25 ans se présente en consultation suite à une chute en trotinette. Il souhaite reconstruire son incisive centrale."
    
    let hypothesis = "Réaliser une couronne céramo-céramique"
    let fracturePhoto = UIImage(named: "fracture_incisive_photo")!
    let fractureRadiography = UIImage(named: "fracture_incisive_radio")!
    sct.questions.append(SctQuestion(hypothesis: hypothesis, newData: SctData(content: .image(fractureRadiography))))
    sct.questions.append(SctQuestion(hypothesis: hypothesis, newData: SctData(image: fracturePhoto)))
    
    return SctExam(scts: [sct])
}

class SctUnfinishedViewController: SctDetailViewController
{
    static let toSctHorizontal = "SctUnfinishedToSctHorizontalSegueId"
    
    var sctUnfinished: SctUnfinished =
        SctUnfinished(session: SctSession(exam: SctExam()),
                      answeredQuestions: 1,
                      duration: 30.0,
                      startDate: Date(),
                      lastDate: Date(),
                      statistics:
            SctStatistics(id: 0,
                          authorLastName: "Tartanpion",
                          authorFirstName: "Jean", meanScore: 10, meanDuration: 94, meanVotes: 4.3, launchesCount: 300, meanCompletionPercentage: 60, scoresDistribution: [], releaseDate: Date()))
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
            target.sctSession = SctSession(exam: imageExam1_())
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
            return [.topic, .authorLastName, .authorFirstName, .meanScore, .questionsCount, .scoreDiagram]
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
    
    var exam: SctExam {
        return sctUnfinished.session.exam
    }
    
    var statistics: SctStatistics {
        return sctUnfinished.statistics
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
