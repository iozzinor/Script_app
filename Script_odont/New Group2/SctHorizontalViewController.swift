//
//  SctHorizontalViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

public class SctHorizontalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    public static let toGoToSct = "SctHorizontalToGoToSctSegueId"
    
    // -------------------------------------------------------------------------
    // MARK: - VALIDATION STATUS
    // -------------------------------------------------------------------------
    fileprivate enum ValidationStatus
    {
        case valid
        case invalid(ValidationError)
    }
    
    fileprivate enum ValidationError
    {
        case insufficientTime(actual: TimeInterval, expected: TimeInterval)
        case insufficientAnsweredScts(actual: Int, expected: Int)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SECTIONS
    // -------------------------------------------------------------------------
    fileprivate enum SctSection: Int, CaseIterable
    {
        case drawing
        case information
        
        func rows(for sct: Sct) -> [SctRow]
        {
            switch self
            {
            case .drawing:
                var result: [SctRow] = [ .wording, .questionHeader ]
                result.append(contentsOf: Array<SctRow>(repeating: .question, count: sct.questions.count))
                
                return result
            case .information:
                return Array<SctRow>(repeating: .scale, count: 5)
            }
        }
        
        func allRows(for sct: Sct) -> [SctRow] {
            return SctSection.allCases.flatMap { $0.rows(for: sct) }
        }
        
        var title: String? {
            switch self
            {
            case .drawing:
                return nil
            case .information:
                return "SctExam.Horizontal.Title.Information".localized
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ROWS
    // -------------------------------------------------------------------------
    fileprivate enum SctRow
    {
        case wording
        case questionHeader
        case question
        case scale
        
        func cell(for indexPath: IndexPath, sctHorizontalViewController: SctHorizontalViewController) -> UITableViewCell
        {
            let tableView = sctHorizontalViewController.tableView!
            let session = sctHorizontalViewController.sctSession
            let currentSct = sctHorizontalViewController.currentSct_
            
            let sct = session.exam.scts[currentSct]
            switch self
            {
            case .wording:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SctHorizontalWordingCell
                cell.wordingLabel.text = sct.wording
                return cell
            case .questionHeader:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SctHorizontalQuestionHeaderCell
                cell.hypothesisLabel.text   = "SctExam.Horizontal.Headers.Hypothesis".localized
                cell.newDataLabel.text      = "SctExam.Horizontal.Headers.NewData".localized
                cell.likertScaleLabel.text  = "SctExam.Horizontal.Headers.Impact".localized
                return cell
            case .question:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SctHorizontalQuestionCell
                cell.question = sct.questions[indexPath.row - 2]
                cell.tag = indexPath.row - 2
                cell.isLast = (indexPath.row - 1 == sct.questions.count)
                
                // restore the answer
                let answer = session[currentSct, indexPath.row - 2]
                cell.setAnswer(answer)
                cell.delegate = sctHorizontalViewController
                return cell
            case .scale:
                let cell = tableView.dequeueReusableCell(for: indexPath) as SctHorizontalScaleCell
                
                let likertSctle = sct.topic.likertSctle
                cell.setScale(code: indexPath.row - 2, description: likertSctle[indexPath.row - 2])
                return cell
            }
        }
    }
    
    fileprivate static let minimumSessionTime_: TimeInterval = 60.0
    fileprivate static let refreshTime_: TimeInterval = 0.5
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var informationItem: UIBarButtonItem!
    weak var informationView: UIStackView!
    weak var progressLabel: UILabel!
    weak var timeLabel: UILabel!
    @IBOutlet weak var previousButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rotateView: UIView!
    
    fileprivate var sessionTimer_: Timer? = nil
    fileprivate var lastTime_: TimeInterval = 0.0
    fileprivate var orientationHorizontal_ = Constants.isDeviceOrientationHorizontal
    
    public var sctSession = SctSession(exam: SctExam(scts: [])) {
        didSet {
            if isViewLoaded
            {
                updateUi_()
            }
        }
    }
    
    fileprivate var currentSct_ = 0 {
        didSet {
            if isViewLoaded
            {
                updateUi_()
            }
        }
    }
    
    deinit
    {
        (UIApplication.shared.delegate as? AppDelegate)?.removeDelegate(self)
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setup_()
        
        // register as application delegate
        (UIApplication.shared.delegate as? AppDelegate)?.registerDelegate(self)
        
        // device changed notification
        NotificationCenter.default.addObserver(self, selector: #selector(SctHorizontalViewController.deviceOrientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    public override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        destroyTimer_()
        createTimer_()
    }
    
    public override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        destroyTimer_()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setup_()
    {
        let newInformationView = UIStackView()
        newInformationView.axis = .horizontal
        newInformationView.alignment = .center
        newInformationView.distribution = .fill
        newInformationView.spacing = 10.0
        
        let newProgressLabel = UILabel()
        progressLabel = newProgressLabel
        
        let newTimeLabel = UILabel()
        timeLabel = newTimeLabel
        
        newInformationView.addArrangedSubview(progressLabel)
        newInformationView.addArrangedSubview(timeLabel)
        
        informationItem.customView = newInformationView
        
        tableView.dataSource    = self
        tableView.delegate      = self
        
        updateUi_()
        
        updateDeviceOrientation_()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UPDATE UI
    // -------------------------------------------------------------------------
    fileprivate func updateUi_()
    {
        updateProgressUi_()
        updateTimeUi_()
        updateNavigationButtons_()
        tableView.reloadData()
    }
    
    fileprivate func updateProgressUi_()
    {
        let progressString = String.localizedStringWithFormat("SctExam.Horizontal.Progress".localized, currentSct_ + 1, sctSession.exam.scts.count)
        progressLabel.text = progressString
    }
    
    fileprivate func updateTimeUi_()
    {
        let minutes = Int(sctSession.time) / 60
        let seconds = Int(sctSession.time) % 60
        
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        
        timeLabel.text = timeString
    }
    
    fileprivate func updateNavigationButtons_()
    {
        previousButton.isEnabled    = (currentSct_ > 0)
        nextButton.isEnabled        = (currentSct_ < sctSession.exam.scts.count - 1)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - TIME
    // -------------------------------------------------------------------------
    fileprivate func createTimer_()
    {
        lastTime_ = Date.timeIntervalSinceReferenceDate
        sessionTimer_ = Timer.scheduledTimer(timeInterval: SctHorizontalViewController.refreshTime_, target: self, selector: #selector(SctHorizontalViewController.updateTime_), userInfo: nil, repeats: true)
    }
    
    fileprivate func destroyTimer_()
    {
        sessionTimer_?.invalidate()
        sessionTimer_ = nil
    }
    
    @objc fileprivate func updateTime_(_ sender: Timer)
    {
        // compute the elapsed time
        let elapsedTime = Date.timeIntervalSinceReferenceDate - lastTime_
        sctSession.time += elapsedTime
        lastTime_ = Date.timeIntervalSinceReferenceDate
        
        // display the time
        updateTimeUi_()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - DEVICE ORIENTATION
    // -------------------------------------------------------------------------
    @objc fileprivate func deviceOrientationChanged(_ sender: Any)
    {
        let newOrientationHorizontal = Constants.isDeviceOrientationHorizontal
        if newOrientationHorizontal != orientationHorizontal_
        {
            orientationHorizontal_ = newOrientationHorizontal
            
            updateDeviceOrientation_()
        }
    }
    
    fileprivate func updateDeviceOrientation_()
    {
        rotateView.isHidden = orientationHorizontal_
        tableView.isHidden = !orientationHorizontal_
    }
    
    // -------------------------------------------------------------------------
    // MARK: - VALIDATION
    // -------------------------------------------------------------------------
    fileprivate func sessionValidationStatus_() -> ValidationStatus
    {
        if sctSession.time < SctHorizontalViewController.minimumSessionTime_
        {
            return .valid // time is only checked server-side
        }
        
        var validScts = 0
        for i in 0..<sctSession.exam.scts.count
        {
            if sctSession.isSctValid(i)
            {
                validScts += 1
            }
        }
        if validScts < (sctSession.exam.scts.count / 2)
        {
            return .invalid(.insufficientAnsweredScts(actual: validScts, expected: sctSession.exam.scts.count / 2))
        }
        return .valid
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @IBAction func cancel(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func previous(_ sender: UIBarButtonItem)
    {
        guard currentSct_ > 0 else
        {
            return
        }
        
        currentSct_ -= 1
        
        updateNavigationButtons_()
    }
    
    @IBAction func next(_ sender: UIBarButtonItem)
    {
        guard currentSct_ < sctSession.exam.scts.count - 1 else
        {
            return
        }
        
        currentSct_ += 1
        
        updateNavigationButtons_()
    }
    
    @IBAction func attemptSubmission(_ sender: UIBarButtonItem)
    {
        switch sessionValidationStatus_()
        {
        case .valid:
            // send the session
            break
        case let .invalid(error):
            destroyTimer_()
            displayError_(error)
        }
    }
    
    fileprivate func displayError_(_ error: ValidationError)
    {
        let errorController = UIAlertController(title: "SctExam.Submission.Error.AlertTitle".localized, message: "", preferredStyle: .alert)
        switch error
        {
        case let .insufficientTime(actual: currentTime, expected: minimumTime):
            errorController.message = String.localizedStringWithFormat("SctExam.Submission.Error.InsufficientTime".localized, minimumTime, currentTime)
        case let .insufficientAnsweredScts(actual: actual, expected: expected):
            errorController.message = String.localizedStringWithFormat("SctExam.Submission.Error.InsufficientAnswers".localized, actual, expected)
        }
        
        let cancelAction = UIAlertAction(title: "Common.Ok".localized, style: .default, handler: {
            (_) -> Void in
            self.createTimer_()
        })
        errorController.addAction(cancelAction)
        
        show(errorController, sender: nil)
    }
    
    @IBAction func displayMoreOptions(_ sender: UIBarButtonItem)
    {
        destroyTimer_()
        
        let optionsController = UIAlertController(title: "SctExam.Horizontal.Options.Title".localized, message: "SctExam.Horizontal.Options.Message".localized, preferredStyle: .actionSheet)
        
        // go to
        let goToAction = UIAlertAction(title: "SctExam.Horizontal.Options.GoTo".localized, style: .default, handler: {
            (_) -> Void in
            self.performSegue(withIdentifier: SctHorizontalViewController.toGoToSct, sender: self)
        })
        
        // cancel
        let cancelAction = UIAlertAction(title: "Common.Cancel".localized, style: .cancel, handler: {
            (_) -> Void in
            self.createTimer_()
        })
        
        optionsController.addAction(goToAction)
        optionsController.addAction(cancelAction)
        
        show(optionsController, sender: nil)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUE
    // -------------------------------------------------------------------------
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == SctHorizontalViewController.toGoToSct,
            let destination = (segue.destination as? UINavigationController)?.viewControllers.first as? GoToSctViewController
        {
            destination.session = sctSession
            destination.currentSct = currentSct_
            destination.delegate = self
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - TABLE VIEW DELEGATE
    // -------------------------------------------------------------------------
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        return nil
    }
    
    // -------------------------------------------------------------------------
    // MARK: - TABLE VIEW DATA SOURCE
    // -------------------------------------------------------------------------
    public func numberOfSections(in tableView: UITableView) -> Int
    {
        return SctSection.allCases.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return SctSection.allCases[section].title
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let section = SctSection.allCases[section]
        return section.rows(for: sctSession.exam.scts[currentSct_]).count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = SctSection.allCases[indexPath.section]
        let rows = section.rows(for: sctSession.exam.scts[currentSct_])
        let row = rows[indexPath.row]
        
        let cell = row.cell(for: indexPath, sctHorizontalViewController: self)
        cell.accessoryType      = .none
        cell.selectionStyle     = .none
        return cell
    }
}

// -----------------------------------------------------------------------------
// MARK: - SCT HORIZONTAL QUESTION CELL DELEGATE
// -----------------------------------------------------------------------------
extension SctHorizontalViewController: SctHorizontalQuestionCellDelegate
{
    public func sctHorizontalQuestionCell(_ sctHorizontalQuestionCell: SctHorizontalQuestionCell, didSelectAnswer answer: LikertSctle.Degree?)
    {
        let questionIndex = sctHorizontalQuestionCell.tag
        sctSession[currentSct_, questionIndex] = answer
    }
}

// -----------------------------------------------------------------------------
// UIApplicationDelegate
// -----------------------------------------------------------------------------
extension SctHorizontalViewController: UIApplicationDelegate
{
    public func applicationWillResignActive(_ application: UIApplication)
    {
        destroyTimer_()
    }
    
    public func applicationWillEnterForeground(_ application: UIApplication)
    {
        createTimer_()
    }
}

// -----------------------------------------------------------------------------
// GoToSctViewControllerDelegate
// -----------------------------------------------------------------------------
extension SctHorizontalViewController: GoToSctViewControllerDelegate
{
    func goToSctViewControllerDidCancel(_ goToSctViewController: GoToSctViewController)
    {
    }
    
    func goToSctViewController(_ goToSctViewController: GoToSctViewController, didChooseSct sctIndex: Int)
    {
        currentSct_ = sctIndex
    }
}
