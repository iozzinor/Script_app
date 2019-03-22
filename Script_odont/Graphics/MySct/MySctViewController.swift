//
//  MySctViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 08/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class MySctViewController: UIViewController
{
    // -------------------------------------------------------------------------
    // MARK: - SECTIONS
    // -------------------------------------------------------------------------
    fileprivate enum MySctSection
    {
        case unfinished([SctUnfinished])
        case finished([SctFinished])
        case progress
        
        var title: String? {
            switch self
            {
            case .unfinished:
                return "MySct.Section.Unfinished".localized
            case .finished:
                return "MySct.Section.Finished".localized
            case .progress:
                return "MySct.Section.Progress".localized
            }
        }
        
        var headerDescription: String?
        {
            switch self
            {
            case .unfinished:
                return "MySct.Section.Unfinished.Description".localized
            case .finished:
                return "MySct.Section.Finished.Description".localized
            case .progress:
                return nil
            }
        }
        
        var rows: [MySctRow]
        {
            switch self
            {
            case let .unfinished(unfinishedScts):
                let lastIndex = min(unfinishedScts.count, MySctViewController.maximumDisplayedScts_)
                let range = unfinishedScts.startIndex..<(unfinishedScts.index(unfinishedScts.startIndex, offsetBy: lastIndex))
                let result = unfinishedScts[range]
                return result.map {
                    return MySctRow.unfinished($0)
                }
            case let .finished(finishedScts):
                let lastIndex = min(finishedScts.count, MySctViewController.maximumDisplayedScts_)
                let range = finishedScts.startIndex..<(finishedScts.index(finishedScts.startIndex, offsetBy: lastIndex))
                let result = finishedScts[range]
                return result.map {
                    return MySctRow.finished($0)
                }
                
            case .progress:
                return [.progress]
            }
        }
        
        var maximumRows: Int?
        {
            switch self
            {
            case .finished(_), .unfinished(_):
                return MySctViewController.maximumDisplayedScts_
            case .progress:
                return 1
            }
        }
        
        var displaySeeAll: Bool {
            switch self
            {
            case let .unfinished(unfinishedScts):
                return unfinishedScts.count > MySctViewController.maximumDisplayedScts_
            case let .finished(finishedScts):
                return finishedScts.count > MySctViewController.maximumDisplayedScts_
            case .progress:
                return false
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ROWS
    // -------------------------------------------------------------------------
    fileprivate enum MySctRow
    {
        case unfinished(SctUnfinished)
        case finished(SctFinished)
        case progress
        
        func cell(for indexPath: IndexPath, mySctViewController: MySctViewController) -> UITableViewCell
        {
            let tableView = mySctViewController.tableView!
            
            switch self
            {
            case let .unfinished(sctUnfinished):
                let cell = tableView.dequeueReusableCell(for: indexPath) as MySctUnfinishedCell
                cell.setSctUnfinished(sctUnfinished)
                return cell
            case let .finished(sctFinished):
                let cell = tableView.dequeueReusableCell(for: indexPath) as MySctFinishedCell
                cell.setSctFinished(sctFinished)
                return cell
            case .progress:
                let cell = UITableViewCell()
                cell.textLabel?.text = "MySct.Progress.Title".localized
                return cell
            }
        }
        
        var accessoryType: UITableViewCell.AccessoryType
        {
            return .disclosureIndicator
        }
    }
    
    public static let toSctUnfinished = "MySctToSctUnfinishedSegueId"
    public static let toSctFinished = "MySctToSctFinishedSegueId"
    public static let toSctsUnfinishedSegueId = "MySctToSctsUnfinishedListSegueId"
    public static let toSctsFinishedSegueId = "MySctToSctsFinishedListSegueId"
    public static let toMySctProgressSegueId = "MySctToMyProgressSegueId"
    
    fileprivate static let maximumDisplayedScts_ = 10
    
    private static func defaultUnfinishedScts_() -> [SctUnfinished]
    {
        var scts = [Sct]()
        
        let sctsCount = Int(arc4random() % 10) + 2
        for _ in 0..<sctsCount
        {
            scts.append(Sct(wording: "", topic: .diagnostic, questions: Array<SctQuestion>(repeating: SctQuestion(), count: 10)))
        }
        
        var unfinishedScts = [SctUnfinished]()
        
        for i in 0..<13
        {
            let topic = SctTopic(rawValue: Constants.random(min: 0, max: 2)) ?? .diagnostic
            scts[0].topic = topic
            let exam = SctExam(scts: scts)
            let session = SctSession(exam: exam)
            
            let answeredQuestions = Constants.random(min: 5, max: 30)
            let duration = Double(Constants.random(min: 50, max: 350))
            let startDate = Date(timeIntervalSinceNow: Double(Constants.random(min: 0, max: 10) * (3600 * 24)))
            
            var scoresDistribution = [Int]()
            for _ in 0..<5
            {
                scoresDistribution.append(Constants.random(min: 10, max: 100))
            }
            
            let statistics = SctStatistics(id: i + 1,
                                           authorLastName: "Tartanpion",
                                           authorFirstName: "Jean",
                                           meanScore:                   Double(Constants.random(min: 5, max: 95)),
                                           meanDuration:                Double(Constants.random(min: 120, max: 300)),
                                           meanVotes:                   Double(Constants.random(min: 0, max: 500)) / 100.0,
                                           launchesCount:               Constants.random(min: 300, max: 1000),
                                           meanCompletionPercentage:    Double(Constants.random(min: 5, max: 95)),
                                           scoresDistribution:          scoresDistribution,
                                           releaseDate:                 Date())
            
            let sctUnfinished = SctUnfinished(session: session, answeredQuestions: answeredQuestions, duration: duration, startDate: startDate, lastDate: Date(), statistics: statistics)
            
            unfinishedScts.append(sctUnfinished)
        }
        
        unfinishedScts.sort(by: { $0.startDate > $1.startDate })
        
        return unfinishedScts
    }
    
    private static func defaultFinishedScts_() -> [SctFinished]
    {
        var scts = [Sct]()
        
        let sctsCount = Int(arc4random() % 10) + 2
        for _ in 0..<sctsCount
        {
            scts.append(Sct(wording: "", topic: .diagnostic, questions: Array<SctQuestion>(repeating: SctQuestion(), count: 10)))
        }
        
        var finishedScts = [SctFinished]()
        
        for i in 0..<5
        {
            let topic = SctTopic(rawValue: Int(arc4random() % 3)) ?? .diagnostic
            scts[0].topic = topic
            let exam = SctExam(scts: scts)
            let session = SctSession(exam: exam)
            
            let answeredQuestions = Int(arc4random() % 30) + 5
            let duration = Double(Int(arc4random() % 300) + 50)
            let startDate = Date(timeIntervalSinceNow: Double(Int(arc4random() % 10 * (3600 * 24))))
            var scoresDistribution = [Int]()
            for _ in 0..<5
            {
                scoresDistribution.append(Constants.random(min: 10, max: 100))
            }
            let statistics = SctStatistics(id: i + 1,
                                           authorLastName: "Tartanpion",
                                           authorFirstName: "Jean",
                                           meanScore:                   Double(Constants.random(min: 5, max: 95)),
                                           meanDuration:                Double(Constants.random(min: 120, max: 300)),
                                           meanVotes:                   Double(Constants.random(min: 0, max: 500)) / 100.0,
                                           launchesCount:               Constants.random(min: 300, max: 1000),
                                           meanCompletionPercentage:    Double(Constants.random(min: 5, max: 95)),
                                           scoresDistribution: scoresDistribution,
                                           releaseDate: Date())
            
            let vote: Int? = nil//(Constants.random(min: 0, max: 100) % 2 == 0 ? nil : 3.75)
            
            let sctUnfinished = SctFinished(session: session, answeredQuestions: answeredQuestions, duration: duration, startDate: startDate, endDate: Date(), statistics: statistics, score: Double(Int(arc4random()) % exam.totalQuestionsCount + 1), vote: vote)
            
            finishedScts.append(sctUnfinished)
        }
        
        finishedScts.sort(by: { $0.startDate > $1.startDate })
        
        return finishedScts
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var sectionHeaders_ = [DetailHeader]()
    fileprivate var sectionFooters_ = [DetailFooter?]()
    fileprivate var sections_: [MySctSection] = [ .unfinished(MySctViewController.defaultUnfinishedScts_()),
                                                  .finished(MySctViewController.defaultFinishedScts_()),
                                                  .progress]
    fileprivate var sctUnfinished_: SctUnfinished? = nil
    fileprivate var sctFinished_: SctFinished? = nil
    fileprivate var unfinishedScts_: [SctUnfinished]? = nil
    fileprivate var finishedScts_: [SctFinished]? = nil
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupSectionHeaders_()
        setupSectionFooters_()
        setupTableView_()
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
    fileprivate func setupSectionHeaders_()
    {
        for section in sections_
        {
            let newHeader = DetailHeader()
            newHeader.sectionTitle = section.title ?? ""
            newHeader.sectionDescription = section.headerDescription
            
            sectionHeaders_.append(newHeader)
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
    
    fileprivate func setupTableView_()
    {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerNibCell(MySctUnfinishedCell.self)
        tableView.registerNibCell(MySctFinishedCell.self)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @objc fileprivate func seeAll_(_ sender: UIButton)
    {
        let sectionIndex = sender.tag
        let section = sections_[sectionIndex]
        
        switch section
        {
        case let .unfinished(unfinishedScts):
            unfinishedScts_ = unfinishedScts
            performSegue(withIdentifier: MySctViewController.toSctsUnfinishedSegueId, sender: self)
        case let .finished(finishedScts):
            finishedScts_ = finishedScts
            performSegue(withIdentifier: MySctViewController.toSctsFinishedSegueId, sender: self)
        case .progress:
            break
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUES
    // -------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // unfinished
        if segue.identifier == MySctViewController.toSctUnfinished,
            let target = segue.destination as? SctUnfinishedViewController,
            let sctUnfinished = sctUnfinished_
        {
            target.sctUnfinished = sctUnfinished
        }
        // finished
        else if segue.identifier == MySctViewController.toSctFinished,
            let target = segue.destination as? SctFinishedViewController,
            let sctFinished = sctFinished_
        {
            target.setSctFinished(sctFinished)
        }
        // unfinished list
        else if segue.identifier == MySctViewController.toSctsUnfinishedSegueId,
            let target = segue.destination as? SctsUnfinishedListViewController,
            let unfinishedScts = unfinishedScts_
        {
            target.unfinishedScts = unfinishedScts
        }
        // finished list
        else if segue.identifier == MySctViewController.toSctsFinishedSegueId,
            let target = segue.destination as? SctsFinishedListViewController,
            let finishedScts = finishedScts_
        {
            target.finishedScts = finishedScts
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - UITableViewDelegate
// -----------------------------------------------------------------------------
extension MySctViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let section = sections_[indexPath.section]
        let row = section.rows[indexPath.row]
        
        switch row
        {
        case let .unfinished(sctUnfinished):
            sctUnfinished_ = sctUnfinished
            performSegue(withIdentifier: MySctViewController.toSctUnfinished, sender: self)
        case let .finished(sctFinished):
            sctFinished_ = sctFinished
            performSegue(withIdentifier: MySctViewController.toSctFinished, sender: self)
        case .progress:
            performSegue(withIdentifier: MySctViewController.toMySctProgressSegueId, sender: self)
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - UITableViewDataSource
// -----------------------------------------------------------------------------
extension MySctViewController: UITableViewDataSource
{
    // header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let currentSection = sections_[section]
        let sectionHeader = sectionHeaders_[section]
        if currentSection.displaySeeAll
        {
            sectionHeader.registerForSeeAllAction(target: self, selector: #selector(MySctViewController.seeAll_), buttonTag: section)
        }
        else
        {
            sectionHeader.unregisterForSeeAllAction(target: self, selector: #selector(MySctViewController.seeAll_))
        }
        
        return sectionHeaders_[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return sectionHeaders_[section].preferredHeight
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return sections_[section].title
    }
    
    // footer
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        sectionFooters_[section]?.updateSize(forWidth: tableView.frame.width)
        return sectionFooters_[section]
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sectionFooters_[section]?.height ?? 0.0
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
        
        let cell = row.cell(for: indexPath, mySctViewController: self)
        cell.selectionStyle = .none
        cell.accessoryType = row.accessoryType
        return cell
    }
}
