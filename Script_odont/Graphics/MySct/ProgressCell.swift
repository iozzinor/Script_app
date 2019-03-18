//
//  ProgressCell.swift
//  Script_odont
//
//  Created by Régis Iozzino on 18/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class ProgressCell: UITableViewCell
{
    fileprivate static let weekFormatter_: DateFormatter = {
        let result = DateFormatter()
        result.dateStyle = .medium
        return result
    }()
    fileprivate static let monthFormatter_: DateFormatter = {
        let result = DateFormatter()
        result.dateFormat = "ProgressCell.Period.MonthFormat".localized
        return result
    }()
    
    @IBOutlet weak var periodControl: UISegmentedControl!
    {
        didSet
        {
            setupPeriodControl_()
        }
    }
    @IBOutlet weak var periodLabel: UILabel!
    {
        didSet
        {
            updatePeriodLabelTitle_()
        }
    }
    @IBOutlet weak var scoreProgressDiagram: ScoreProgressDiagram!
    
    weak var delegate: ProgressCellDelegate? = nil
    
    fileprivate var currentPeriod_ = Period.day{
        didSet
        {
            updatePeriodLabelTitle_()
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setupPeriodControl_()
    {
        periodControl.removeAllSegments()
        for (i, period) in Period.allCases.enumerated()
        {
            periodControl.insertSegment(withTitle: period.shortName, at: i, animated: false)
        }
        
        periodControl.selectedSegmentIndex = 0
        periodControl.addTarget(self, action: #selector(ProgressCell.choosePeriod_), for: .valueChanged)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UPDATE UI
    // -------------------------------------------------------------------------
    fileprivate func updatePeriodLabelTitle_()
    {
        let today = Date()
        let calendar = Calendar.current
        
        switch currentPeriod_
        {
        // today
        case .day:
            periodLabel.text = "ProgressCell.Period.Today".localized
        // <short start> - <short end>
        case .week:
            var endComponents = calendar.dateComponents(Set([Calendar.Component.weekOfYear, .weekday, .year, .hour, .minute, .second]), from: today)
            endComponents.weekday = 7
            
            if let endDate = calendar.date(from: endComponents)
            {
                let startDate = endDate.addingTimeInterval(-6 * 24 * 3600.0)
                let startString = ProgressCell.weekFormatter_.string(from: startDate)
                let endString   = ProgressCell.weekFormatter_.string(from: endDate)
                
                periodLabel.text = String.localizedStringWithFormat("ProgressCell.Period.WeekFormat".localized, startString, endString)
            }
            
        // <month> <year>
        case .month:
            let monthString = ProgressCell.monthFormatter_.string(from: today)
            
            periodLabel.text = monthString
            
        // <year>
        case .year:
            let components = calendar.dateComponents(Set([Calendar.Component.year]), from: today)
            if let year = components.year
            {
                periodLabel.text = "\(year)"
            }
        }
    }

    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @objc fileprivate func choosePeriod_(_ sender: UISegmentedControl)
    {
        let period = Period.allCases[sender.selectedSegmentIndex]
        currentPeriod_ = period
        delegate?.progressCell(self, didChoosePeriod: period)
    }
}
