//
//  SctLaunchViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 17/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

fileprivate func defaultSct_() -> Sct
{
    var first = SctQuestion()
    // TEMP
    first.wording = "Un patient de 34 ans se présente en consultation pour des douleurs intenses sur 36 depuis plusieurs jours. Cette dent a déjà été reconstitué par un onlay MOD 4 ans plus tôt."
    
    first.items.append(SctItem(hypothesis: "une fracture amélo-dentinaire", newData: SctData(text: " un sondage parodontal de 8 mm en vestibulaire")))
    first.items.append(SctItem(hypothesis: "une reprise carieuse et une pulpite sous l’onlay", newData: SctData(text: "  le test au froid est négatif")))
    first.items.append(SctItem(hypothesis: "une reprise carieuse et à une pulpite sous l’onlay", newData: SctData(text: "    Il y a une douleur à la palpation et à la percussion de la dent")))
    first.items.append(SctItem(hypothesis: "une surcharge occlusale", newData: SctData(text: "   le papier d’occlusion marque principalement sur les cuspides linguales")))
    
    var second = SctQuestion()
    second.topic = .therapeutic
    second.wording = "Une patiente de 25 ans se présente en consultation pour la reconstruction de sa dent 11 qui ne présente ni douleur ni dyschromie."
    second.items.append(SctItem(hypothesis: "réaliser un composite en technique direct", newData: SctData(text:  "sa dent a déja été reconstruite par plusieurs composite qui sont étanches")))
    second.items.append(SctItem(hypothesis: "réaliser un composite en technique direct", newData: SctData(text:  "le test au froid est négatif")))
    second.items.append(SctItem(hypothesis: "réaliser une facette", newData: SctData(text:  "la zone de collage est quasi intégralement dentinaire")))
    second.items.append(SctItem(hypothesis: "réaliser une facette", newData: SctData(text:  "le patient est bruxomane")))
    
    var third = SctQuestion()
    third.topic = .therapeutic
    third.wording = "Un patient de 70 ans se présente pour son rendez-vous de contrôle 1 semaine après la pose d’une prothèse amovible complète bi-maxillaire. Il se plaint de douleurs"
    third.items.append(SctItem(hypothesis: "Des prématurités et/ou interférences occlusales", newData: SctData(text:  "Il y a des blessures gingivales")))
    third.items.append(SctItem(hypothesis: "Une erreur de dimension verticale d’occlusion", newData: SctData(text:  "La phonation est difficile")))
    third.items.append(SctItem(hypothesis: "Une erreur lors des empreintes", newData: SctData(text:  "Il n’y a ni sous-extensions, ni sur-extensions des bases prothétiques")))
    
    return Sct(questions: [first, second, third])
}

class SctLaunchViewController: SctDetailViewController
{
    static let toSctHorizontal = "SctLaunchToSctHorizontalSegueId"
    
    @IBOutlet weak var tableView: UITableView!
    
    var launchInformation = SctLaunchInformation(sct: Sct(questions: []),
                                                 statistics: SctStatistics(id: 0,
                                                                           authorLastName: "Tartanpion",
                                                                           authorFirstName: "Jean",meanScore: 10, meanDuration: 94, meanVotes: 4.3, launchesCount: 300, meanCompletionPercentage: 60, scoresDistribution: [], releaseDate: Date()))
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
        if segue.identifier == SctLaunchViewController.toSctHorizontal,
            let target = segue.destination as? SctHorizontalViewController
        {
            target.sctSession = SctSession(sct: defaultSct_())
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
        performSegue(withIdentifier: SctLaunchViewController.toSctHorizontal, sender: self)
    }
}

// -----------------------------------------------------------------------------
// MARK: - SCT DETAIL VIEW DATA SOURCE
// -----------------------------------------------------------------------------
extension SctLaunchViewController: SctDetailViewDataSource
{
    var sct: Sct {
        return launchInformation.sct
    }
    
    var statistics: SctStatistics {
        return launchInformation.statistics
    }
    
    var answeredQuestionsCount: Int {
        return launchInformation.sct.totalItemsCount
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
            return [.topic, .authorLastName, .authorFirstName, .meanScore, .questionsCount, .scoreDiagram]
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
