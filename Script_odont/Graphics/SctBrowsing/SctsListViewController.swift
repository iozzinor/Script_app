//
//  SctsListViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 17/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class SctsListViewController: UITableViewController
{
    // -------------------------------------------------------------------------
    // MARK: - SCTS LIST
    // -------------------------------------------------------------------------
    struct SctsList
    {
        enum Category
        {
            case period(Period)
            case top
            case personnalized
            case topic(QualificationTopic)
            
            var name: String
            {
                switch self
                {
                case let .period(latestPeriod):
                    switch latestPeriod
                    {
                    case .day:
                        return "SctsList.Category.Today.Name".localized
                    case .week:
                        return "SctsList.Category.LastWeek.Name".localized
                    case .month:
                        return "SctsList.Category.LastMonth.Name".localized
                    case .year:
                        return ""
                    }
                case .top:
                    return "SctsList.Category.Top.Name".localized
                case .personnalized:
                    return "SctsList.Category.Personnalized.Name".localized
                case let .topic(qualificationTopic):
                    return qualificationTopic.name
                }
            }
        }
        
        var category: Category
        
        var launchInformation: [SctLaunchInformation]
    }
    
    static let toSctLaunchSegueId = "SctsListToSctLaunchSegueId"
    
    fileprivate var noSctsLabel_ = UILabel()
    fileprivate var sctsList_ = SctsList(category: .period(.day), launchInformation: [])
    fileprivate var pickedIndex_ = -1
    var sctsList: SctsList
    {
        set
        {
            sctsList_ = newValue
            if isViewLoaded
            {
                tableView.reloadData()
            }
        }
        get {
            return sctsList_
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupNoSctsLabel_()
        setupTableView_()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        navigationItem.title = sctsList_.category.name
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setupNoSctsLabel_()
    {
        noSctsLabel_.text = "SctsList.NoScts".localized
        noSctsLabel_.textColor = Appearance.Color.missing
        noSctsLabel_.textAlignment = .center
    }
    
    fileprivate func setupTableView_()
    {
        tableView.registerNibCell(SctBrowsingCell.self)
        tableView.reloadData()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUE
    // -------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == SctsListViewController.toSctLaunchSegueId,
            let target = segue.destination as? SctLaunchViewController
        {
            target.launchInformation = sctsList.launchInformation[pickedIndex_]
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DELEGATE
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        pickedIndex_ = indexPath.row
        performSegue(withIdentifier: SctsListViewController.toSctLaunchSegueId, sender: self)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI TABLE VIEW DATA SOURCE
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    {
        if sctsList_.launchInformation.isEmpty
        {
            return noSctsLabel_
        }
        return nil
    }
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        if sctsList_.launchInformation.isEmpty
        {
            return noSctsLabel_.systemLayoutSizeFitting(view.frame.size).height
        }
        return 0.0
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return sctsList_.launchInformation.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(for: indexPath) as SctBrowsingCell
        
        cell.setSctLaunchInformation(sctsList_.launchInformation[indexPath.row])
        cell.informationLabel.text = ""
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}
