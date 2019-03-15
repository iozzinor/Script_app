//
//  ViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 20/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SctBrowsingViewController: UIViewController
{
    // -------------------------------------------------------------------------
    // MARK: - BROWSING SECTION
    // -------------------------------------------------------------------------
    fileprivate enum BrowsingSection
    {
        /*
         10 most recent sct
         date (year, month, week) + count
        */
        case new
        
        /*
         10 best rated scts
         see all
        */
        case top
        
        /*
         10 personnalised scts
         see + count
        */
        case personnalized
        
        // topic + count
        case topics
        
        case search
        
        var headerTitle: String? {
            switch self
            {
            case .new:
                return "ScrBrowsing.Section.New.Title".localized
            case .top:
                return "ScrBrowsing.Section.Top.Title".localized
            case .personnalized:
                return "ScrBrowsing.Section.Personnalized.Title".localized
            case .topics:
                return "ScrBrowsing.Section.Topics.Title".localized
            case .search:
                return "ScrBrowsing.Section.Search.Title".localized
            }
        }
        
        var rows: [BrowsingRow] {
            switch self
            {
            case .new:
                return Array<BrowsingRow>(repeating: .newSct(Sct()), count: 10)
            case .top:
                return Array<BrowsingRow>(repeating: .top(Sct()), count: 10)
            case .personnalized:
                return []
            case .topics:
                return QualificationTopic.allCases.map { .topic($0) }
            case .search:
                return [.search]
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - BROWSING ROW
    // -------------------------------------------------------------------------
    fileprivate enum BrowsingRow
    {
        case newSct(Sct)
        case newDate()
        case top(Sct)
        
        case topic(QualificationTopic)
        
        case search
        
        func cell(for indexPath: IndexPath, tableView: UITableView, sctBrowsingViewController: SctBrowsingViewController) -> UITableViewCell
        {
            let cell = UITableViewCell()
            cell.accessoryType = .none
            
            switch self
            {
            case let .newSct(sct):
                cell.textLabel?.text = "New SCT \(sct.questions.count)"
            case .search:
                cell.textLabel?.text = "Want more ? Click here !"
                cell.accessoryType = .disclosureIndicator
            case let .topic(topic):
                
                let result = UITableViewCell(style: .value1, reuseIdentifier: nil)
                result.textLabel?.text = topic.name
                result.detailTextLabel?.text = "\(Constants.random(min: 10, max: 20))"
                result.selectionStyle = .none
                
                result.accessoryType = .disclosureIndicator
                return result
            default:
                break
            }
            return cell
        }
    }
    
    static let scaHorizontalSegueId = "MainToSctHorizontalSegueId"
    static let walkthroughSegueId = "MainToWalkthroughSegueId"
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var checkFirstTime_ = false
    fileprivate let sections_: [BrowsingSection] = [.new, .top, .topics, .personnalized, .search]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if !checkFirstTime_ && UIApplication.isFirstLaunch
        {
            checkFirstTime_ = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                 self.launchWalkthrough_()
            })
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUES
    // -------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        switch segue.identifier
        {
        case SctBrowsingViewController.scaHorizontalSegueId:
            prepareForSctHorizontal(segue: segue, sender: sender)
        default:
            break
        }
    }
    
    fileprivate func prepareForSctHorizontal(segue: UIStoryboardSegue, sender: Any?)
    {
        if let destination = segue.destination as? SctHorizontalViewController
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
            
            let exam = SctExam(scts: [first, second, third])
            let session = SctSession(exam: exam)
            session.time = 50 
            destination.sctSession = session
        }
    }
    
    fileprivate func launchWalkthrough_()
    {
        performSegue(withIdentifier: SctBrowsingViewController.walkthroughSegueId,
                     sender: self)
    }
}

// -----------------------------------------------------------------------------
// MARK: - UITableViewDelegate
// -----------------------------------------------------------------------------
extension SctBrowsingViewController: UITableViewDelegate
{
    
}

// -----------------------------------------------------------------------------
// MARK: - UITableViewDataSource
// -----------------------------------------------------------------------------
extension SctBrowsingViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let currentSection = sections_[section]
        return currentSection.headerTitle
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return sections_.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let currentSection = sections_[section]
        return currentSection.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = sections_[indexPath.section]
        let row = section.rows[indexPath.row]
        
        return row.cell(for: indexPath, tableView: tableView, sctBrowsingViewController: self)
    }
}
