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
    fileprivate struct LatestDate
    {
        var period: LatestPeriod
        var launchInformation: [SctLaunchInformation]
        var sctCount: Int {
            return launchInformation.count
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - QUALIFICATION TOPIC LIST
    // -------------------------------------------------------------------------
    fileprivate struct QualificationTopicList
    {
        var topic: QualificationTopic
        var launchInformation: [SctLaunchInformation]
        var count: Int {
            return launchInformation.count
        }
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
                result.informationLabel.text = Constants.formatReal(meanVotes)
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
    
    static let walkthroughSegueId = "SctBrowsingToWalkthroughSegueId"
    static let searchSegueId = "SctBrowsingToSctSearchSegueId"
    static let toSctsListSegueId = "SctBrowsingToSctsListSegueId"
    static let toSctLaunchSegueId = "SctBrowsingToSctLaunchSegueId"
    
    static let topicCellId = "SctBrowsingTopicCellReuseId"
    static let searchCellId = "SctBrowsingSearchCellReuseId"
    
    fileprivate static let sectionSeparatorHeight_:     CGFloat = 1.0
    fileprivate static let sectionSeparatorWidthRatio_: CGFloat = 0.8
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var checkFirstTime_ = false
    fileprivate let sections_: [BrowsingSection] = [.new, .top, .topics, .personnalized, .search]
    fileprivate var sectionHeaders_ = [DetailHeader]()
    fileprivate var sectionFooters_ = [DetailFooter?]()
    fileprivate var launchInformation_: SctLaunchInformation? = nil
    fileprivate var sctsList_: SctsListViewController.SctsList? = nil
    
    // -------------------------------------------------------------------------
    // MARK: - SCTS LISTS
    // -------------------------------------------------------------------------
    fileprivate var newScts_: [SctLaunchInformation] {
        return Array<SctLaunchInformation>(repeating: sctLaunchInformation_(), count: 10)
    }
    fileprivate var todayScts_: [SctLaunchInformation] {
        return Array<SctLaunchInformation>(repeating: sctLaunchInformation_(), count: 0)
    }
    fileprivate var lastWeekScts_: [SctLaunchInformation] {
        return Array<SctLaunchInformation>(repeating: sctLaunchInformation_(), count: 2)
    }
    fileprivate var lastMonthScts_: [SctLaunchInformation] {
        return Array<SctLaunchInformation>(repeating: sctLaunchInformation_(), count: 4)
    }
    fileprivate var topLaunchScts_: [SctLaunchInformation] {
        return Array<SctLaunchInformation>(repeating: sctLaunchInformation_(), count: 5)
    }
    fileprivate var topRateScts_: [SctLaunchInformation] {
        return Array<SctLaunchInformation>(repeating: sctLaunchInformation_(), count: 5)
    }
    fileprivate var topScts_: [SctLaunchInformation] {
        var result = topLaunchScts_
        result.append(contentsOf: topRateScts_)
        return result
    }
    fileprivate var personnalizedScts_: [SctLaunchInformation] {
        return Array<SctLaunchInformation>(repeating: sctLaunchInformation_(), count: 10)
    }
    
    fileprivate func rows_(forSection section: BrowsingSection) -> [BrowsingRow]
    {
        switch section
        {
        case .new:
            var result = newScts_.map { BrowsingRow.newSct($0) }
            
            result.append(.newDate(LatestDate(period: .day,     launchInformation: todayScts_)))
            result.append(.newDate(LatestDate(period: .week,    launchInformation: lastWeekScts_)))
            result.append(.newDate(LatestDate(period: .month,   launchInformation: lastMonthScts_)))
            
            return result
        case .top:
            var result = topLaunchScts_.map { BrowsingRow.topLaunch($0) }
            result.append(contentsOf: topRateScts_.map { BrowsingRow.topRate($0) })
            return result
        case .personnalized:
            return Array<BrowsingRow>(repeating: .personnalizedSct(sctLaunchInformation_()), count: 5)
        case .topics:
            let topicLaunchInformation = Array<SctLaunchInformation>(repeating: sctLaunchInformation_(), count: 5)
            return QualificationTopic.allCases.map { .topic(QualificationTopicList(topic: $0, launchInformation: topicLaunchInformation)) }
        case .search:
            return [.search]
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupTableView_()
        setupSectionHeaders_()
        setupSectionFooters_()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
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
            let newSectionHeader = DetailHeader()
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
            let newFooter = DetailFooter()
            newFooter.backgroundColor = UIColor.white
            sectionFooters_.append(newFooter)
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
        case SctBrowsingViewController.toSctsListSegueId:
            prepareForSctsList_(segue: segue, sender: sender)
        case SctBrowsingViewController.toSctLaunchSegueId:
            prepareForSctLaunch_(segue: segue, sender: sender)
        default:
            break
        }
    }
    
    fileprivate func prepareForSctLaunch_(segue: UIStoryboardSegue, sender: Any?)
    {
        if let destination = segue.destination as? SctLaunchViewController,
            let launchInformation = launchInformation_
        {
            destination.launchInformation = launchInformation 
        }
    }
    
    fileprivate func prepareForSctsList_(segue: UIStoryboardSegue, sender: Any?)
    {
        if let destination = segue.destination as? SctsListViewController,
            let list = sctsList_
        {
            destination.sctsList = list
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    fileprivate func launchWalkthrough_()
    {
        performSegue(withIdentifier: SctBrowsingViewController.walkthroughSegueId,
                     sender: self)
    }
    
    @objc fileprivate func showAll_(sender: UIButton)
    {
        let currentSection = sections_[sender.tag]
        switch currentSection
        {
        case .personnalized:
            let listCategory = SctsListViewController.SctsList.Category.personnalized
            let list = SctsListViewController.SctsList(category: listCategory, launchInformation: personnalizedScts_)
            displaySctsList_(list)
        case .top:
            let listCategory = SctsListViewController.SctsList.Category.top
            let list = SctsListViewController.SctsList(category: listCategory, launchInformation: topScts_)
            displaySctsList_(list)
        case .new, .topics, .search:
            break
        }
    }
    
    fileprivate func displayLaunchInformation(_ launchInformation: SctLaunchInformation)
    {
        launchInformation_ = launchInformation
        performSegue(withIdentifier: SctBrowsingViewController.toSctLaunchSegueId, sender: self)
    }
    
    fileprivate func displaySctsList_(_ list: SctsListViewController.SctsList)
    {
        sctsList_ = list
        performSegue(withIdentifier: SctBrowsingViewController.toSctsListSegueId, sender: self)
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
        let row = rows_(forSection: section)[indexPath.row]
        
        switch row
        {
        case let .newSct(launchInformation), let .topLaunch(launchInformation),
             let .topRate(launchInformation), let .personnalizedSct(launchInformation):
            displayLaunchInformation(launchInformation)
        case let .newDate(latestDate):
            
            let listCategory = SctsListViewController.SctsList.Category.period(latestDate.period)
            let list = SctsListViewController.SctsList(category: listCategory, launchInformation: latestDate.launchInformation)
            displaySctsList_(list)
            
        case let .topic(qualificationTopicList):
            let listCategory = SctsListViewController.SctsList.Category.topic(qualificationTopicList.topic)
            let list = SctsListViewController.SctsList(category: listCategory, launchInformation: qualificationTopicList.launchInformation)
            displaySctsList_(list)
            
        case .search:
            launchSearch_()
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
        sectionFooters_[section]?.updateSize(forWidth: tableView.frame.width)
        
        return sectionFooters_[section]
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return sectionFooters_[section]?.height ?? 0.0
    }
    
    // cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let currentSection = sections_[section]
        return rows_(forSection: currentSection).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = sections_[indexPath.section]
        let row = rows_(forSection: section)[indexPath.row]
        
        let cell = row.cell(for: indexPath, tableView: tableView, sctBrowsingViewController: self)
        cell.accessoryType = row.accessoryType(for: indexPath, tableView: tableView, sctBrowsingViewController: self)
        cell.selectionStyle = row.selectionStyle(for: indexPath, tableView: tableView, sctBrowsingViewController: self)
        return cell
    }
}
