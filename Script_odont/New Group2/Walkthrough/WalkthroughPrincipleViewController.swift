//
//  WalkthroughPrincipleViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 21/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class WalkthroughPrincipleViewController: UIViewController
{
    // -------------------------------------------------------------------------
    // STEP
    // -------------------------------------------------------------------------
    enum Step: Int, CaseIterable
    {
        case drawing
        case wording
        case hypothesis
        case newData
        case lickertScale
        
        var next: Step {
            let newValue = (self.rawValue < Step.allCases.count - 1 ? self.rawValue + 1 : 0)
            return Step(rawValue: newValue)!
        }
        
        var description: String {
            switch self
            {
            case .drawing:
                return "Un TCS est classiquement représenté sous la forme d'une vignette."
            case .wording:
                return "Le titre de cette vignette est l'énoncé : il s'agit de la description du cas du patient."
            case .hypothesis:
                return "Les hyptohèses sont rangées dans la première colonne."
            case .newData:
                return "Chaque nouvelle donnée modifie la probabilité des hypothèses conçues auparavant."
            case .lickertScale:
                return "L'impact d'une nouvelle donnée sur une hypothèse peut être évalué avec l'échelle de Lickert en 5 points allant de -2 à 2."
            }
        }
    }
    
    fileprivate static let stepTime_: Double = 2.0
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var focusView: UIView!
    
    fileprivate var currentStep_ = Step.drawing {
        didSet {
            updateStepUi_()
        }
    }
    fileprivate var stepTimer_: Timer? =  nil
    var displayStepLabel = true
    
    deinit
    {
         (UIApplication.shared.delegate as? AppDelegate)?.removeDelegate(self)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        (UIApplication.shared.delegate as? AppDelegate)?.registerDelegate(self)
        
        titleLabel.text = WalkthroughPageViewController.WalkthroughSection.principle.title
        
        tableView.delegate = self
        tableView.dataSource = self
        
        focusView                   = UIView()
        focusView.backgroundColor   = UIColor.clear
        focusView.layer.borderColor = UIColor.red.cgColor
        focusView.layer.borderWidth = 3
        tableView.addSubview(focusView)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // reset the step
        currentStep_ = Step.drawing
        
        createTimer_()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        destroyTimer_()
    }
    
    @objc fileprivate func updateStep_(_ sender: Any)
    {
        if displayStepLabel
        {
            currentStep_ = currentStep_.next
            displayStepLabel = false
        }
        else
        {
            displayStepLabel = true
            DispatchQueue.main.asyncAfter(deadline: .now() + (WalkthroughPrincipleViewController.stepTime_ - 1.5), execute: {
                
                UIView.animate(withDuration: 1, animations: {
                    self.stepLabel?.alpha = 0
                })
            })
        }
        
    }
    
    fileprivate func updateStepUi_()
    {
        stepLabel.text = currentStep_.description
        stepLabel.alpha = 0
        UIView.animate(withDuration: 1.0, animations:
            {
                self.stepLabel.alpha = 1
        })
        
        let firstCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! WalkthroughPrincipleCell
        let lastCell = tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as! WalkthroughPrincipleCell
        let firstLabel: UITextView
        let lastLabel: UITextView
        
        switch currentStep_
        {
        case .drawing:
            focusView.frame = tableView.frame
            focusView.frame.origin = CGPoint.zero
            
            return
        case .wording:
            let firstCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! WalkthroughPrincipleCell
            let firstLabel = firstCell.labels.first!
            let frame = firstLabel.convert(firstLabel.frame, to: tableView)
            
            focusView.frame = frame
            
            return
        case .hypothesis:
            firstLabel  = firstCell.labels[0]
            lastLabel   = lastCell.labels[0]
        case .newData:
            firstLabel  = firstCell.labels[1]
            lastLabel   = lastCell.labels[1]
        case .lickertScale:
            firstLabel  = firstCell.labels[2]
            lastLabel   = lastCell.labels[2]
        }
        let firstFrame  = firstLabel.convert(firstLabel.bounds, to: tableView)
        let lastFrame   = lastLabel.convert(lastLabel.bounds, to: tableView)
        
        let width = firstFrame.width
        let height = lastFrame.maxY - firstFrame.minY
        
        focusView.frame = CGRect(x: firstFrame.minX, y: firstFrame.minY, width: width, height: height)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Timer
    // -------------------------------------------------------------------------
    fileprivate func createTimer_()
    {
        stepTimer_ = Timer.scheduledTimer(timeInterval: WalkthroughPrincipleViewController.stepTime_, target: self, selector: #selector(WalkthroughPrincipleViewController.updateStep_), userInfo: nil, repeats: true)
    }
    
    fileprivate func destroyTimer_()
    {
        stepTimer_?.invalidate()
        stepTimer_ = nil
    }
}

// -----------------------------------------------------------------------------
// UIApplicationDelegate
// -----------------------------------------------------------------------------
extension WalkthroughPrincipleViewController: UIApplicationDelegate
{
    func applicationWillResignActive(_ application: UIApplication)
    {
        destroyTimer_()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication)
    {
        createTimer_()
    }
}

// -----------------------------------------------------------------------------
// UITableViewDelegate
// -----------------------------------------------------------------------------
extension WalkthroughPrincipleViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // display the focus frame when the table has been rendered
        if indexPath.row == 5
        {
            focusView.frame = tableView.frame
            focusView.frame.origin = CGPoint.zero
        }
    }
}

// -----------------------------------------------------------------------------
// UITableViewDataSource
// -----------------------------------------------------------------------------
extension WalkthroughPrincipleViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(for: indexPath) as WalkthroughPrincipleCell
        
        cell.cellsCount = (indexPath.row == 0 ? 1 : 3)
    
        switch indexPath.row
        {
        case 0:
            cell.labels.first?.text = "Enonce"
        case 1:
            cell.labels[0].text = "Vous pensiez..."
            cell.labels[1].text = "Vous trouvez..."
            cell.labels[2].text = "Indice de Lickert"
        case 4:
            cell.labels[0].text = ""
            cell.labels[1].text = "..."
            cell.labels[2].text = ""
        default:
            cell.labels[0].text = "H\(indexPath.row - 2)"
            cell.labels[1].text = "D\(indexPath.row - 2)"
            cell.labels[2].text = "I\(indexPath.row - 2)"
        }
        
        return cell
    }
}
