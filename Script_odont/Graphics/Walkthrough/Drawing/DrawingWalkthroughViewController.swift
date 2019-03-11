//
//  WalkthroughPrincipleViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 21/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class DrawingWalkthroughViewController: SctViewController
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
                return "DrawingWalkthrough.Description.Drawing".localized
            case .wording:
                return "DrawingWalkthrough.Description.Wording".localized
            case .hypothesis:
                return "DrawingWalkthrough.Description.Hypothesis".localized
            case .newData:
                return "DrawingWalkthrough.Description.NewData".localized
            case .lickertScale:
                return "DrawingWalkthrough.Description.LikertScale".localized
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
        
        setupTableView(tableView)
        dataSource = self
        
        titleLabel.text = WelcomeWalkthroughPageViewController.WelcomeWalkthroughSection.welcome.title
        
        focusView                   = UIView()
        focusView.backgroundColor   = UIColor.clear
        focusView.layer.borderColor = UIColor.red.cgColor
        focusView.layer.borderWidth = 3
        tableView.addSubview(focusView)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + (DrawingWalkthroughViewController.stepTime_ - 1.5), execute: {
                
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
        
        /*let firstCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as! DrawingWalkthroughCell
        let lastCell = tableView.cellForRow(at: IndexPath(row: 5, section: 0)) as! DrawingWalkthroughCell
        let firstLabel: UITextView
        let lastLabel: UITextView
        
        switch currentStep_
        {
        case .drawing:
            focusView.frame = tableView.frame
            focusView.frame.origin = CGPoint.zero
            
            return
        case .wording:
            let firstCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! DrawingWalkthroughCell
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
        case .lickertSctle:
            firstLabel  = firstCell.labels[2]
            lastLabel   = lastCell.labels[2]
        }
        let firstFrame  = firstLabel.convert(firstLabel.bounds, to: tableView)
        let lastFrame   = lastLabel.convert(lastLabel.bounds, to: tableView)
        
        let width = firstFrame.width
        let height = lastFrame.maxY - firstFrame.minY
        
        focusView.frame = CGRect(x: firstFrame.minX, y: firstFrame.minY, width: width, height: height)*/
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Actions
    // -------------------------------------------------------------------------
    @IBAction func done(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Timer
    // -------------------------------------------------------------------------
    fileprivate func createTimer_()
    {
        stepTimer_ = Timer.scheduledTimer(timeInterval: DrawingWalkthroughViewController.stepTime_, target: self, selector: #selector(DrawingWalkthroughViewController.updateStep_), userInfo: nil, repeats: true)
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
extension DrawingWalkthroughViewController: UIApplicationDelegate
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
// MARK: - SctViewDataSource
// -----------------------------------------------------------------------------
extension DrawingWalkthroughViewController: SctViewDataSource
{
    var sections: [SctViewController.SctSection] {
        return [ .drawing ]
    }
    
    var currentSctIndex: Int {
        return 0
    }
    
    var currentSct: Sct {
        let wording = "DrawingWalkthrough.Drawing.Wording".localized
        
        var questions = [SctQuestion]()
        questions.append(SctQuestion(hypothesis: "", newData: "..."))
        
        for i in 1...2
        {
            questions.append(SctQuestion(hypothesis: "H\(i)", newData: "D\(i)"))
        }
        return Sct(wording: wording, topic: .diagnostic, questions: questions)
    }
    
    var questionHeaderTitle: SctQuestionHeaderCell.Title? {
        return SctQuestionHeaderCell.Title(hypothesis: "DrawingWalkthrough.Drawing.Think".localized, newData: "DrawingWalkthrough.Drawing.Find".localized, likertScale: "DrawingWalkthrough.Drawing.LikertIndex".localized)
    }
    
    var session: SctSession? {
        return nil
    }
    
    var canChooseLikertScale: Bool {
        return false
    }
    
    func sctQuestionCell(_ sctQuestionCell: SctQuestionCell, didSelectAnswer answer: LikertScale.Degree?)
    {
    }
}
    
    /*func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(for: indexPath) as DrawingWalkthroughCell
        
        cell.cellsCount = (indexPath.row == 0 ? 1 : 3)
    
        switch indexPath.row
        {
        case 0:
 
        }
        
        return cell
    }*/

