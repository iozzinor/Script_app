//
//  ScaHorizontalViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

public class ScaHorizontalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    public static let toGoToSca = "ScaHorizontalToGoToScaSegueId"
    
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
        case insufficientAnsweredScas(actual: Int, expected: Int)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SECTIONS
    // -------------------------------------------------------------------------
    fileprivate enum ScaSection: Int, CaseIterable
    {
        case drawing
        case information
        
        func rows(for sca: Sca) -> [ScaRow]
        {
            switch self
            {
            case .drawing:
                var result: [ScaRow] = [ .wording, .questionHeader ]
                result.append(contentsOf: Array<ScaRow>(repeating: .question, count: sca.questions.count))
                
                return result
            case .information:
                return Array<ScaRow>(repeating: .scale, count: 5)
            }
        }
        
        func allRows(for sca: Sca) -> [ScaRow] {
            return ScaSection.allCases.flatMap { $0.rows(for: sca) }
        }
        
        var title: String? {
            switch self
            {
            case .drawing:
                return nil
            case .information:
                return "ScaExam.Horizontal.Title.Information".localized
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ROWS
    // -------------------------------------------------------------------------
    fileprivate enum ScaRow
    {
        case wording
        case questionHeader
        case question
        case scale
        
        func cell(for indexPath: IndexPath, scaHorizontalViewController: ScaHorizontalViewController) -> UITableViewCell
        {
            let tableView = scaHorizontalViewController.tableView!
            let session = scaHorizontalViewController.scaSession
            let currentSca = scaHorizontalViewController.currentSca_
            
            let sca = session.exam.scas[currentSca]
            switch self
            {
            case .wording:
                let cell = tableView.dequeueReusableCell(for: indexPath) as ScaHorizontalWordingCell
                cell.wordingLabel.text = sca.wording
                return cell
            case .questionHeader:
                let cell = tableView.dequeueReusableCell(for: indexPath) as ScaHorizontalQuestionHeaderCell
                cell.hypothesisLabel.text   = "ScaExam.Horizontal.Headers.Hypothesis".localized
                cell.newDataLabel.text      = "ScaExam.Horizontal.Headers.NewData".localized
                cell.likertScaleLabel.text  = "ScaExam.Horizontal.Headers.Impact".localized
                return cell
            case .question:
                let cell = tableView.dequeueReusableCell(for: indexPath) as ScaHorizontalQuestionCell
                cell.question = sca.questions[indexPath.row - 2]
                cell.tag = indexPath.row - 2
                cell.isLast = (indexPath.row - 1 == sca.questions.count)
                
                // restore the answer
                let answer = session[currentSca, indexPath.row - 2]
                cell.setAnswer(answer)
                cell.delegate = scaHorizontalViewController
                return cell
            case .scale:
                let cell = tableView.dequeueReusableCell(for: indexPath) as ScaHorizontalScaleCell
                
                let likertScale = sca.topic.likertScale
                cell.setScale(code: indexPath.row - 2, description: likertScale[indexPath.row - 2])
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
    
    public var scaSession = ScaSession(exam: ScaExam(scas: [])) {
        didSet {
            if isViewLoaded
            {
                updateUi_()
            }
        }
    }
    
    fileprivate var currentSca_ = 0 {
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
        NotificationCenter.default.addObserver(self, selector: #selector(ScaHorizontalViewController.deviceOrientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
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
        let progressString = String.localizedStringWithFormat("ScaExam.Horizontal.Progress".localized, currentSca_ + 1, scaSession.exam.scas.count)
        progressLabel.text = progressString
    }
    
    fileprivate func updateTimeUi_()
    {
        let minutes = Int(scaSession.time) / 60
        let seconds = Int(scaSession.time) % 60
        
        let timeString = String(format: "%02d:%02d", minutes, seconds)
        
        timeLabel.text = timeString
    }
    
    fileprivate func updateNavigationButtons_()
    {
        previousButton.isEnabled    = (currentSca_ > 0)
        nextButton.isEnabled        = (currentSca_ < scaSession.exam.scas.count - 1)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - TIME
    // -------------------------------------------------------------------------
    fileprivate func createTimer_()
    {
        lastTime_ = Date.timeIntervalSinceReferenceDate
        sessionTimer_ = Timer.scheduledTimer(timeInterval: ScaHorizontalViewController.refreshTime_, target: self, selector: #selector(ScaHorizontalViewController.updateTime_), userInfo: nil, repeats: true)
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
        scaSession.time += elapsedTime
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
        if scaSession.time < ScaHorizontalViewController.minimumSessionTime_
        {
            return .valid // time is only checked server-side
        }
        
        var validScas = 0
        for i in 0..<scaSession.exam.scas.count
        {
            if scaSession.isScaValid(i)
            {
                validScas += 1
            }
        }
        if validScas < (scaSession.exam.scas.count / 2)
        {
            return .invalid(.insufficientAnsweredScas(actual: validScas, expected: scaSession.exam.scas.count / 2))
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
        guard currentSca_ > 0 else
        {
            return
        }
        
        currentSca_ -= 1
        
        updateNavigationButtons_()
    }
    
    @IBAction func next(_ sender: UIBarButtonItem)
    {
        guard currentSca_ < scaSession.exam.scas.count - 1 else
        {
            return
        }
        
        currentSca_ += 1
        
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
        let errorController = UIAlertController(title: "ScaExam.Submission.Error.AlertTitle".localized, message: "", preferredStyle: .alert)
        switch error
        {
        case let .insufficientTime(actual: currentTime, expected: minimumTime):
            errorController.message = String.localizedStringWithFormat("ScaExam.Submission.Error.InsufficientTime".localized, minimumTime, currentTime)
        case let .insufficientAnsweredScas(actual: actual, expected: expected):
            errorController.message = String.localizedStringWithFormat("ScaExam.Submission.Error.InsufficientAnswers".localized, actual, expected)
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
        
        let optionsController = UIAlertController(title: "ScaExam.Horizontal.Options.Title".localized, message: "ScaExam.Horizontal.Options.Message".localized, preferredStyle: .actionSheet)
        
        // go to
        let goToAction = UIAlertAction(title: "ScaExam.Horizontal.Options.GoTo".localized, style: .default, handler: {
            (_) -> Void in
            self.performSegue(withIdentifier: ScaHorizontalViewController.toGoToSca, sender: self)
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
        if segue.identifier == ScaHorizontalViewController.toGoToSca,
            let destination = (segue.destination as? UINavigationController)?.viewControllers.first as? GoToScaViewController
        {
            destination.session = scaSession
            destination.currentSca = currentSca_
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
        return ScaSection.allCases.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return ScaSection.allCases[section].title
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let section = ScaSection.allCases[section]
        return section.rows(for: scaSession.exam.scas[currentSca_]).count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section = ScaSection.allCases[indexPath.section]
        let rows = section.rows(for: scaSession.exam.scas[currentSca_])
        let row = rows[indexPath.row]
        
        let cell = row.cell(for: indexPath, scaHorizontalViewController: self)
        cell.accessoryType      = .none
        cell.selectionStyle     = .none
        return cell
    }
}

// -----------------------------------------------------------------------------
// MARK: - SCA HORIZONTAL QUESTION CELL DELEGATE
// -----------------------------------------------------------------------------
extension ScaHorizontalViewController: ScaHorizontalQuestionCellDelegate
{
    public func scaHorizontalQuestionCell(_ scaHorizontalQuestionCell: ScaHorizontalQuestionCell, didSelectAnswer answer: LikertScale.Degree?)
    {
        let questionIndex = scaHorizontalQuestionCell.tag
        scaSession[currentSca_, questionIndex] = answer
    }
}

// -----------------------------------------------------------------------------
// UIApplicationDelegate
// -----------------------------------------------------------------------------
extension ScaHorizontalViewController: UIApplicationDelegate
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
// GoToScaViewControllerDelegate
// -----------------------------------------------------------------------------
extension ScaHorizontalViewController: GoToScaViewControllerDelegate
{
    func goToScaViewControllerDidCancel(_ goToScaViewController: GoToScaViewController)
    {
    }
    
    func goToScaViewController(_ goToScaViewController: GoToScaViewController, didChooseSca scaIndex: Int)
    {
        currentSca_ = scaIndex
    }
}
