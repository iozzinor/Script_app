//
//  WalkthroughTypesViewContoller.swift
//  Script_odont
//
//  Created by Régis Iozzino on 21/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class WalkthroughTypesViewController: UITableViewController
{
    static let cellReuseId = "WalkthroughTypesDefaultCellReuseId"
    
    // -------------------------------------------------------------------------
    // MARK: - SCA ROWS
    // -------------------------------------------------------------------------
    enum ScaType: Int, CaseIterable
    {
        case diagnostic
        case therapeutic
        case prognostic
        
        var name: String {
            switch self
            {
            case .diagnostic:
                return "Diagnostic"
            case .therapeutic:
                return "Therapeutic"
            case .prognostic:
                return "Prognostic"
            }
        }
        
        var next: ScaType {
            let index = (self.rawValue < ScaType.allCases.count - 1 ? self.rawValue + 1 : 0)
            return ScaType(rawValue: index)!
        }
    }
    
    enum ScaSection: Int, CaseIterable
    {
        case description
        case typeList
        case lickertScale
        
        var rows: [ScaRow] {
            switch self
            {
            case .description:
                return [ .description ]
            case .typeList:
                var result = [ScaRow]()
                
                for i in 0..<ScaType.allCases.count
                {
                    result.append(ScaRow.scaType(i))
                }
                
                return result
            case .lickertScale:
                return [ .lickertScale ]
            }
        }
    }
    
    enum ScaRow
    {
        case description
        case scaType(Int)
        case lickertScale
        
        var title: String {
            switch self
            {
            case .description:
                return "types description"
            case let .scaType(index):
                return ScaType.allCases[index].name
            case .lickertScale:
                return "lickert scale"
            }
        }
        
        var isSelectable: Bool {
            
            switch self
            {
            case .description:
                return false
            case .scaType, .lickertScale:
                return true
            }
        }
    }
    
    fileprivate static let typeTime: Double = 2
    
    fileprivate var currentType_ = ScaType.diagnostic
    fileprivate var typeTimer_: Timer? = nil
    fileprivate var displayCounter_ = 1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.delegate      = self
        tableView.dataSource    = self
        
        tableView.backgroundColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        typeTimer_ = Timer.scheduledTimer(timeInterval: WalkthroughTypesViewController.typeTime, target: self, selector: #selector(WalkthroughTypesViewController.updateDisplayedType_), userInfo: nil, repeats: true)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDelegate
    // -------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        let section = ScaSection.allCases[indexPath.section]
        let row = section.rows[indexPath.row]
        
        return row.isSelectable ? indexPath : nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.selectRow(at: nil, animated: true, scrollPosition: .none)
        
        if indexPath.section == 2
        {
            currentType_ = currentType_.next
        }
        else
        {
            currentType_ = ScaType(rawValue: indexPath.row)!
        }
        
        displayCounter_ = -1
        animateOut_()
    }
    
    fileprivate func animateIn_()
    {
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! WalkthroughTypesCell
        cell.categoryLabel.frame.origin = CGPoint(x: cell.frame.width, y: cell.categoryLabel.frame.origin.y)
        
        UIView.animate(withDuration: 0.5, animations: {
            cell.categoryLabel.frame.origin = CGPoint.zero
        })
        
        for (i, label) in cell.lickertLabels.enumerated()
        {
            CATransaction.begin()
            label.layer.removeAllAnimations()
            CATransaction.commit()
            
            label.frame.origin = CGPoint(x: cell.frame.width, y: label.frame.origin.y)
            
            UIView.animate(withDuration: 0.7, delay: Double(i) * 0.2 + 0.4, usingSpringWithDamping: 0.6, initialSpringVelocity: 10.0, options: [.curveEaseInOut], animations: {
                label.frame.origin = CGPoint(x: 0, y: label.frame.origin.y)
            }, completion: nil)
        }
    }
    
    fileprivate func animateOut_()
    {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! WalkthroughTypesCell
        cell.categoryLabel.frame.origin = CGPoint.zero
        
        UIView.animate(withDuration: 0.5, animations: {
            cell.categoryLabel.frame.origin = CGPoint(x: -cell.frame.width, y: 0)
        })
        
        let completion: (Bool) -> Void = {_ in
            self.updateName_()
        }
        for (i, label) in cell.lickertLabels.enumerated()
        {
            label.frame.origin = CGPoint(x: 0, y: label.frame.origin.y)
            
            let animationCompletion: ((Bool) -> Void)? = ((i < cell.lickertLabels.count - 1) ? nil : completion)
            
            UIView.animate(withDuration: 0.3, delay: Double(i) * 0.2 + 0.4, usingSpringWithDamping: 1.0, initialSpringVelocity: 10.0, options: [], animations: {
                label.frame.origin = CGPoint(x: -label.frame.width, y: label.frame.origin.y)
            }, completion: animationCompletion)
        }
    }
    
    @objc fileprivate func updateDisplayedType_(_ sender: Any)
    {
        displayCounter_ += 1
        if displayCounter_ == 0
        {
            animateIn_()
        }
        else if displayCounter_ > 2
        {
            currentType_ = currentType_.next
            displayCounter_ = -1
            animateOut_()
        }
    }
    
    fileprivate func updateName_()
    {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! WalkthroughTypesCell
        cell.categoryLabel.text = self.currentType_.name
        switch self.currentType_
        {
        case .diagnostic:
            cell.lickertLabels[0].text = "hypothèse pratiquement éliminée"
            cell.lickertLabels[1].text = "hypothèse devient moins probable"
            cell.lickertLabels[2].text = "information n'a pas d'effet sur l'hypothèse"
            cell.lickertLabels[3].text = "hypothèse devient plus probable"
            cell.lickertLabels[4].text = "il ne peut s'agir pratiquement que de cette hypothèse"
        case .prognostic:
            cell.lickertLabels[0].text = "-2"
            cell.lickertLabels[1].text = "-1"
            cell.lickertLabels[2].text = " 0"
            cell.lickertLabels[3].text = "+1"
            cell.lickertLabels[4].text = "+2"
        case .therapeutic:
            cell.lickertLabels[0].text = "absolument contre-indiqué"
            cell.lickertLabels[1].text = "moins indiqué"
            cell.lickertLabels[2].text = "ni contre-indiqué ni indiqué"
            cell.lickertLabels[3].text = "indiqué"
            cell.lickertLabels[4].text = "indispensable"
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UITableViewDataSource
    // -------------------------------------------------------------------------
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return ScaSection.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return ScaSection.allCases[section].rows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section < 2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: WalkthroughTypesViewController.cellReuseId, for: indexPath)
            
            let section = ScaSection.allCases[indexPath.section]
            let row = section.rows[indexPath.row]
            
            cell.textLabel?.text = row.title
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(for: indexPath) as WalkthroughTypesCell
        
        cell.categoryLabel.text = currentType_.name
        
        return cell
    }
}
