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
    
    override func viewDidAppear(_ animated: Bool)
    {
        updateFocusViewFrame_()
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
        updateStepLabel_()
        updateFocusViewFrame_()
    }
    
    fileprivate func updateStepLabel_()
    {
        stepLabel.text = currentStep_.description
        stepLabel.alpha = 0
        UIView.animate(withDuration: 1.0, animations:
            {
                self.stepLabel.alpha = 1
        })
    }
    
    fileprivate func updateFocusViewFrame_()
    {
        let wordingCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SctWordingCell
        
        var newFrame: CGRect? = nil
        switch currentStep_
        {
        case .drawing:
            newFrame = drawingFrame()
        case .wording:
            newFrame = wordingCell?.frame
        case .hypothesis:
            newFrame = hypothesisFrame()
        case .newData:
            newFrame = newDataFrame()
        case .lickertScale:
            newFrame = likertScaleFrame()
        }
        
        if newFrame != nil
        {
            focusView.frame = newFrame!
        }
    }
    
    fileprivate func drawingFrame() -> CGRect?
    {
        guard let firstCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SctWordingCell,
            let lastCell = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? SctQuestionCell else
        {
            return nil
        }
        
        let x = firstCell.frame.minX
        let y = firstCell.frame.minY
        let width = firstCell.frame.width
        let height = lastCell.frame.maxY - firstCell.frame.minY
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    fileprivate func hypothesisFrame() -> CGRect?
    {
        return frameForColumn(headerLabelGetter: {$0.hypothesisLabel}, labelGetter: {$0.hypothesisLabel})
    }
    
    fileprivate func newDataFrame() -> CGRect?
    {
        return frameForColumn(headerLabelGetter: {$0.newDataLabel}, labelGetter: {$0.newDataLabel})
    }
    
    fileprivate func likertScaleFrame() -> CGRect?
    {
        return frameForColumn(headerLabelGetter: {$0.likertScaleLabel}, labelGetter: {$0.scalesContainer})
    }
    
    fileprivate func frameForColumn(headerLabelGetter: (SctQuestionHeaderCell) -> UILabel, labelGetter: (SctQuestionCell) -> UIView) -> CGRect?
    {
        guard let firstCell = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? SctQuestionHeaderCell,
            let lastCell = tableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? SctQuestionCell else
        {
            return nil
        }
        
        let firstLabel = headerLabelGetter(firstCell)
        let lastLabel = labelGetter(lastCell)
        
        let x = (firstLabel.superview?.frame.minX ?? 0) + firstLabel.frame.minX
        let y = firstCell.frame.minY
        let width = lastLabel.frame.width
        let height = lastCell.frame.maxY - firstCell.frame.minY
        
        return CGRect(x: x, y: y, width: width, height: height)
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
