//
//  SctLaunchViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 17/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

fileprivate func defaultExam_() -> SctExam
{
    var first = Sct()
    // TEMP
    first.wording = "Un patient de 34 ans se présente en consultation pour des douleurs intenses sur 36 depuis plusieurs jours. Cette dent a déjà été reconstitué par un onlay MOD 4 ans plus tôt."
    
    first.questions.append(SctQuestion(hypothesis: "une fracture amélo-dentinaire", newData:" un sondage parodontal de 8 mm en vestibulaire"))
    first.questions.append(SctQuestion(hypothesis: "une reprise carieuse et une pulpite sous l’onlay", newData:"  le test au froid est négatif"))
    first.questions.append(SctQuestion(hypothesis: "une reprise carieuse et à une pulpite sous l’onlay", newData:"    Il y a une douleur à la palpation et à la percussion de la dent"))
    first.questions.append(SctQuestion(hypothesis: "une surcharge occlusale", newData:"   le papier d’occlusion marque principalement sur les cuspides linguales"))
    
    var second = Sct()
    second.topic = .therapeutic
    second.wording = "Une patiente de 25 ans se présente en consultation pour la reconstruction de sa dent 11 qui ne présente ni douleur ni dyschromie."
    second.questions.append(SctQuestion(hypothesis: "réaliser un composite en technique direct", newData: "sa dent a déja été reconstruite par plusieurs composite qui sont étanches"))
    second.questions.append(SctQuestion(hypothesis: "réaliser un composite en technique direct", newData: "le test au froid est négatif"))
    second.questions.append(SctQuestion(hypothesis: "réaliser une facette", newData: "la zone de collage est quasi intégralement dentinaire"))
    second.questions.append(SctQuestion(hypothesis: "réaliser une facette", newData: "le patient est bruxomane"))
    
    var third = Sct()
    third.topic = .therapeutic
    third.wording = "Un patient de 70 ans se présente pour son rendez-vous de contrôle 1 semaine après la pose d’une prothèse amovible complète bi-maxillaire. Il se plaint de douleurs"
    third.questions.append(SctQuestion(hypothesis: "Des prématurités et/ou interférences occlusales", newData: "Il y a des blessures gingivales"))
    third.questions.append(SctQuestion(hypothesis: "Une erreur de dimension verticale d’occlusion", newData: "La phonation est difficile"))
    third.questions.append(SctQuestion(hypothesis: "Une erreur lors des empreintes", newData: "Il n’y a ni sous-extensions, ni sur-extensions des bases prothétiques"))
    
    return SctExam(scts: [first, second, third])
}

class SctLaunchViewController: SctDetailViewController
{
    static let toSctHorizontalSegueId = "SctLaunchToSctHorizontalSegueId"
    
    @IBOutlet weak var tableView: UITableView!
    
    var launchInformation = SctLaunchInformation(exam: SctExam(scts: []),
                                                 statistics: SctStatistics(id: 0, meanScore: 10, meanDuration: 94, meanVotes: 4.3, launchesCount: 300, meanCompletionPercentage: 60, scoresDistribution: [], releaseDate: Date()))
    {
        didSet
        {
            if isViewLoaded
            {
                super.reloadData()
            }
        }
    }
    
    let sections: [SctDetailViewController.SctDetailSection] = [ .general, .duration, .popularity, .other]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        setupTableView(tableView)
    }
    
    // -----------------------------------------------------------------------------
    // MARK: - SEGUE
    // -----------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == SctLaunchViewController.toSctHorizontalSegueId,
            let target = segue.destination as? SctHorizontalViewController
        {
            target.sctSession = SctSession(exam: defaultExam_())
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - SCT DETAIL VIEW DELEGATE
// -----------------------------------------------------------------------------
extension SctLaunchViewController: SctDetailViewDelegate
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
    }
    
    func sctDetailView(didLaunch sctDetailViewController: SctDetailViewController)
    {
        performSegue(withIdentifier: SctLaunchViewController.toSctHorizontalSegueId, sender: self)
    }
}

// -----------------------------------------------------------------------------
// MARK: - SCT DETAIL VIEW DATA SOURCE
// -----------------------------------------------------------------------------
extension SctLaunchViewController: SctDetailViewDataSource
{
    var exam: SctExam {
        return launchInformation.exam
    }
    
    var statistics: SctStatistics {
        return launchInformation.statistics
    }
    
    var answeredQuestionsCount: Int {
        return launchInformation.exam.totalQuestionsCount
    }
    
    var unfinished: SctUnfinished? {
        return nil
    }
    
    var finished: SctFinished? {
        return nil
    }
    
    func rows(for section: SctDetailViewController.SctDetailSection, at index: Int) -> [SctDetailViewController.SctDetailRow]
    {
        switch section
        {
        case .general:
            return [.topic, .meanScore, .questionsCount, .scoreDiagram]
        case .lastSession, .rate, .results:
            return []
        case .duration:
            return [.estimatedDuration, .meanDuration]
        case .popularity:
            return [.votes, .launchesCount, .meanCompletionPercentage]
        case .other:
            return [.launch]
        }
    }
}
