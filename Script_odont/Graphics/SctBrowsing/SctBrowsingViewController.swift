//
//  ViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 20/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

let releaseDate = Date(timeIntervalSinceNow: -50)

fileprivate func sctLaunchInformation_() -> SctLaunchInformation
{
    let topic = SctTopic(rawValue: Constants.random(min: 0, max: SctTopic.allCases.count - 1))!
    
    var exam = SctExam()
    exam.scts.append(Sct(wording: "", topic: topic, questions: []))
    
    return SctLaunchInformation(exam: exam, statistics: SctStatistics(id: 1,
                                                                           meanScore: 10.0,
                                                                           meanDuration: 34,
                                                                           meanVotes: Double(Constants.random(min: 100, max: 500)) / 100.0,
                                                                           launchesCount: Constants.random(min: 0, max: 10),
                                                                           meanCompletionPercentage: 89, scoresDistribution: [],
                                                                           releaseDate: releaseDate))
}

class SctBrowsingViewController: UIViewController
{
    // -------------------------------------------------------------------------
    // MARK: - LATEST PERIOD
    // -------------------------------------------------------------------------
    fileprivate enum LatestPeriod
    {
        case day
        case week
        case month
        
        var name: String {
            switch self
            {
            case .day:
                return "SctBrowsing.LatestPeriod.Day.Name".localized
            case .week:
                return "SctBrowsing.LatestPeriod.Week.Name".localized
            case .month:
                return "SctBrowsing.LatestPeriod.Month.Name".localized
            }
        }
    }
    
    fileprivate struct LatestDate
    {
        var period: LatestPeriod
        var sctCount: Int
    }
    
    // -------------------------------------------------------------------------
    // MARK: - QUALIFICATION TOPIC LIST
    // -------------------------------------------------------------------------
    fileprivate struct QualificationTopicList
    {
        var topic: QualificationTopic
        var count: Int
    }
    
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
        
        var headerDescription: String? {
            switch self
            {
            case .new:
                return "ScrBrowsing.Section.New.Description".localized
            case .top:
                return "ScrBrowsing.Section.Top.Description".localized
            case .personnalized:
                return "ScrBrowsing.Section.Personnalized.Description".localized
            case .topics:
                return "ScrBrowsing.Section.Topics.Description".localized
            case .search:
                return nil
            }
        }
        
        var displaySeeAll: Bool {
            switch self
            {
            case .personnalized, .top:
                return true
            case .new, .topics, .search:
                return false
            }
        }
        
        var rows: [BrowsingRow] {
            switch self
            {
            case .new:
                var result =  Array<BrowsingRow>(repeating: .newSct(sctLaunchInformation_()), count: 10)
                
                result.append(.newDate(LatestDate(period: .day,     sctCount: 10)))
                result.append(.newDate(LatestDate(period: .week,    sctCount: 100)))
                result.append(.newDate(LatestDate(period: .month,   sctCount: 2)))
                
                return result
            case .top:
                var result = Array<BrowsingRow>(repeating: .topLaunch(sctLaunchInformation_()), count: 5)
                result.append(contentsOf: Array<BrowsingRow>(repeating: .topRate(sctLaunchInformation_()), count: 5))
                return result
            case .personnalized:
                return Array<BrowsingRow>(repeating: .personnalizedSct(sctLaunchInformation_()), count: 5)
            case .topics:
                return QualificationTopic.allCases.map { .topic(QualificationTopicList(topic: $0, count: 5)) }
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
        case newSct(SctLaunchInformation)
        case newDate(LatestDate)
        
        case topLaunch(SctLaunchInformation)
        case topRate(SctLaunchInformation)
        
        case topic(QualificationTopicList)
        
        case personnalizedSct(SctLaunchInformation)
        
        case search
        
        func cell(for indexPath: IndexPath, tableView: UITableView, sctBrowsingViewController: SctBrowsingViewController) -> UITableViewCell
        {
            let numberFormatter = NumberFormatter()
            numberFormatter.locale = Locale.current
            numberFormatter.minimumFractionDigits = 1
            numberFormatter.maximumFractionDigits = 1
            numberFormatter.maximumIntegerDigits = 9
            numberFormatter.minimumIntegerDigits = 1
            
            switch self
            {
            case let .newSct(sctLaunchInformation):
                let result = tableView.dequeueReusableCell(for: indexPath) as SctBrowsingCell
                result.setSctLaunchInformation(sctLaunchInformation)
                
                let seconds = -Int(sctLaunchInformation.statistics.releaseDate.timeIntervalSinceNow)
                let minutes = seconds / 60
                let hours = minutes / 60
                
                let durationText: String
                if hours > 0
                {
                    durationText = String.localizedStringWithFormat("Time.Hour".localized, hours)
                }
                else if minutes > 0
                {
                    durationText = String.localizedStringWithFormat("Time.Minute".localized, minutes)
                }
                else
                {
                    durationText = String.localizedStringWithFormat("Time.Second".localized, seconds)
                }
                result.informationLabel.text = String.localizedStringWithFormat("SctBrowsing.NewSct.Time".localized, durationText)
                
                return result
            case let .newDate(latestDate):
                let result = tableView.dequeueReusableCell(for: indexPath) as SctLatestPeriodCell
                
                result.setPeriod(latestDate.period.name, sctsCount: latestDate.sctCount)
                
                return result
                
            case let .topLaunch(sctLaunchInformation):
                let result = tableView.dequeueReusableCell(for: indexPath) as SctBrowsingCell
                result.setSctLaunchInformation(sctLaunchInformation)
                result.informationLabel.text = String.localizedStringWithFormat("SctBrowsing.LaunchCount".localized, sctLaunchInformation.statistics.launchesCount)
                return result
            case let .topRate(sctLaunchInformation):
                let result = tableView.dequeueReusableCell(for: indexPath) as SctBrowsingCell
                result.setSctLaunchInformation(sctLaunchInformation)
                let meanVotes = sctLaunchInformation.statistics.meanVotes
                result.informationLabel.text = numberFormatter.string(from: NSNumber(value: meanVotes))
                return result
                
            case let .topic(topicList):
                let result = tableView.dequeueReusableCell(withIdentifier: SctBrowsingViewController.topicCellId, for: indexPath)
                result.textLabel?.text = topicList.topic.name
                result.detailTextLabel?.text = "\(topicList.count)"
                return result
                
            case let .personnalizedSct(sctLaunchInformation):
                let result = tableView.dequeueReusableCell(for: indexPath) as SctBrowsingCell
                result.setSctLaunchInformation(sctLaunchInformation)
                result.informationLabel.text = ""
                
                return result
                
            case .search:
                let result = tableView.dequeueReusableCell(for: indexPath) as ButtonCell
                result.setTitle("SctBrowsing.Search.Title".localized)
                
                return result
            }
        }
        
        func accessoryType(for indexPath: IndexPath, tableView: UITableView, sctBrowsingViewController: SctBrowsingViewController) -> UITableViewCell.AccessoryType
        {
            switch self
            {
            case .search:
                return .none
            case .newSct(_), .newDate(_), .topLaunch(_), .topRate(_), .topic(_), .personnalizedSct(_):
                return .disclosureIndicator
            }
        }
        
        func selectionStyle(for indexPath: IndexPath, tableView: UITableView, sctBrowsingViewController: SctBrowsingViewController) -> UITableViewCell.SelectionStyle
        {
            return .none
        }
    }
    
    static let scaHorizontalSegueId = "SctBrowsingToSctHorizontalSegueId"
    static let walkthroughSegueId = "SctBrowsingToWalkthroughSegueId"
    static let searchSegueId = "SctBrowsingToSctSearchSegueId"
    
    static let topicCellId = "SctBrowsingTopicCellReuseId"
    static let searchCellId = "SctBrowsingSearchCellReuseId"
    
    fileprivate static let sectionSeparatorHeight_:     CGFloat = 1.0
    fileprivate static let sectionSeparatorWidthRatio_: CGFloat = 0.8
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var checkFirstTime_ = false
    fileprivate let sections_: [BrowsingSection] = [.new, .top, .topics, .personnalized, .search]
    fileprivate var sectionHeaders_ = [SctBrowsingSection]()
    fileprivate var sectionFooters_ = [UIView?]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupTableView_()
        setupSectionHeaders_()
        setupSectionFooters_()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setupTableView_()
    {
        tableView.delegate = self
        tableView.dataSource = self
     
        tableView.registerNibCell(SctLatestPeriodCell.self)
        tableView.registerNibCell(SctBrowsingCell.self)
        tableView.registerNibCell(ButtonCell.self)
    }
    
    fileprivate func setupSectionHeaders_()
    {
        for (i, section) in sections_.enumerated()
        {
            let newSectionHeader = SctBrowsingSection()
            newSectionHeader.sectionTitle = section.headerTitle ?? ""
            newSectionHeader.sectionDescription = section.headerDescription
            
            if section.displaySeeAll
            {
                newSectionHeader.registerForSeeAllAction(target: self, selector: #selector(SctBrowsingViewController.showAll_), buttonTag: i)
            }
            
            sectionHeaders_.append(newSectionHeader)
        }
    }
    
    fileprivate func setupSectionFooters_()
    {
        for _ in 0..<(sections_.count - 1)
        {
            let newView = UIView()
            newView.backgroundColor = UIColor.gray
            sectionFooters_.append(newView)
        }
        sectionFooters_.append(nil)
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
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUES
    // -------------------------------------------------------------------------
    fileprivate func launchWalkthrough_()
    {
        performSegue(withIdentifier: SctBrowsingViewController.walkthroughSegueId,
                     sender: self)
    }
    
    @objc fileprivate func showAll_(sender: UIButton)
    {
        print("show all for section \(sender.tag)")
    }
    
    fileprivate func launchSearch_()
    {
        performSegue(withIdentifier: SctBrowsingViewController.searchSegueId, sender: self)
    }
}

// -----------------------------------------------------------------------------
// MARK: - UITableViewDelegate
// -----------------------------------------------------------------------------
extension SctBrowsingViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let section = sections_[indexPath.section]
        
        switch section
        {
        case .search:
            launchSearch_()
        case .new, .personnalized, .top, .topics:
            break
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - UITableViewDataSource
// -----------------------------------------------------------------------------
extension SctBrowsingViewController: UITableViewDataSource
{
    // header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let currentSection = sections_[section]
        return currentSection.headerTitle
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return sectionHeaders_[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return sectionHeaders_[section].preferredHeight
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return sections_.count
    }
    
    // footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        let footerWidth = tableView.frame.width * SctBrowsingViewController.sectionSeparatorWidthRatio_
        let emptySpace = tableView.frame.width - footerWidth
        
        let footerMask = CAShapeLayer()
        footerMask.path = UIBezierPath(rect: CGRect(x: emptySpace / 2, y: 0, width: footerWidth, height: SctBrowsingViewController.sectionSeparatorHeight_)).cgPath
        sectionFooters_[section]?.layer.mask = footerMask
        
        return sectionFooters_[section]
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        if sectionFooters_[section] != nil
        {
            return SctBrowsingViewController.sectionSeparatorHeight_
        }
        return 0.0
    }
    
    // cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let currentSection = sections_[section]
        return currentSection.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = sections_[indexPath.section]
        let row = section.rows[indexPath.row]
        
        let cell = row.cell(for: indexPath, tableView: tableView, sctBrowsingViewController: self)
        cell.accessoryType = row.accessoryType(for: indexPath, tableView: tableView, sctBrowsingViewController: self)
        cell.selectionStyle = row.selectionStyle(for: indexPath, tableView: tableView, sctBrowsingViewController: self)
        return cell
    }
}
