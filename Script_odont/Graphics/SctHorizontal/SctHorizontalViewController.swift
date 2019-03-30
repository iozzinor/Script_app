//
//  SctHorizontalViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit
import SceneKit

public class SctHorizontalViewController: SctViewController, SctViewDataSource
{
    public static let toGoToSct     = "SctHorizontalToGoToSctSegueId"
    public static let toImageDetail = "SctHorizontalToImageDetailSegueId"
    public static let toVolume      = "SctHorizontalToVolumeSegueId"
    
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
    
    var senderImageView: UIImageView? = nil
    fileprivate var detailImage_: UIImage? {
        return senderImageView?.image
    }
    fileprivate var senderVolumeView_: SCNView? = nil
    
    var sctSession = SctSession(exam: SctExam(scts: [])) {
        didSet {
            singleQuestionIndexes_ = Array<Int>(repeating: 0, count: sctSession.exam.scts.count)
            if isViewLoaded
            {
                updateUi_()
            }
        }
    }
    
    public var newDataDelegate: NewDataDelegate? {
        return self
    }
    public var sections: [SctViewController.SctSection] {
        return SctViewController.SctSection.allCases
    }
    public var session: SctSession? {
        return sctSession
    }
    
    public var currentSctIndex = 0 {
        didSet {
            if isViewLoaded
            {
                updateUi_()
            }
        }
    }
    
    public var currentSct: Sct
    {
        return sctSession.exam.scts[currentSctIndex]
    }
    
    public var questionHeaderTitle: SctQuestionHeaderCell.Title? = nil
    
    public let canChooseLikertScale: Bool = true
    
    public let shouldDisplaySingleQuestion: Bool = true
    
    fileprivate var singleQuestionIndexes_ = [Int]()
    public var singleQuestionIndex: Int? {
        return singleQuestionIndexes_[currentSctIndex]
    }
    
    deinit
    {
        (UIApplication.shared.delegate as? AppDelegate)?.removeDelegate(self)
    }
    
    public override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setup_()
        
        dataSource = self
        
        // register as application delegate
        (UIApplication.shared.delegate as? AppDelegate)?.registerDelegate(self)
        
        // device changed notification
        NotificationCenter.default.addObserver(self, selector: #selector(SctHorizontalViewController.deviceOrientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    public override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        destroyTimer_()
        createTimer_()
        
        senderImageView = nil
        senderVolumeView_ = nil
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
        setupInformationView_()
        setupRotateView_()
        setupTableView(tableView)
        
        updateUi_()
        
        updateDeviceOrientation_()
    }
    
    fileprivate func setupInformationView_()
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
    }
    
    fileprivate func setupRotateView_()
    {
        rotateView.layer.cornerRadius = 5.0
        
        let rotateLabel = UILabel()
        rotateLabel.text = "SctExam.Horizontal.RotateLabel.Title".localized
        rotateLabel.translatesAutoresizingMaskIntoConstraints = false
        rotateView.addSubview(rotateLabel)
        rotateLabel.sizeToFit()
        
        let centerX = NSLayoutConstraint(item: rotateLabel, attribute: .centerX, relatedBy: .equal, toItem: rotateView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let centerY = NSLayoutConstraint(item: rotateLabel, attribute: .centerY, relatedBy: .equal, toItem: rotateView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        rotateView.addConstraints([centerX, centerY])
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
        let progressString = String.localizedStringWithFormat("SctExam.Horizontal.Progress".localized, currentSctIndex + 1, sctSession.exam.scts.count)
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
        previousButton.isEnabled    = (currentSctIndex > 0)
        nextButton.isEnabled        = (currentSctIndex < sctSession.exam.scts.count - 1)
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
        view.bringSubviewToFront(rotateView)
        
        if !orientationHorizontal_
        {
           displayRotateView_()
        }
    }
    
    fileprivate func displayRotateView_()
    {
        rotateView.alpha = 0.0
        UIView.animate(withDuration: 1.0, animations: {
            self.rotateView.alpha = 1.0
        }, completion: {
            (_) -> Void in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.hideRotateView_()
            })
        })
    }
    
    fileprivate func hideRotateView_()
    {
        UIView.animate(withDuration: 1.0, animations: {
            self.rotateView.alpha = 0.0
        })
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
    // MARK: - SCT VIEW DATA SOURCE
    // -------------------------------------------------------------------------
    public func sctQuestionCell(didSelectPreviousQuestion sctQuestionCell: SctQuestionCell)
    {
        singleQuestionIndexes_[currentSctIndex] -= 1
        tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
    }
    
    public func sctQuestionCell(didSelectNextQuestion sctQuestionCell: SctQuestionCell)
    {
        singleQuestionIndexes_[currentSctIndex] += 1
        tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .automatic)
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
        guard currentSctIndex > 0 else
        {
            return
        }
        
        currentSctIndex -= 1
        
        updateNavigationButtons_()
    }
    
    @IBAction func next(_ sender: UIBarButtonItem)
    {
        guard currentSctIndex < sctSession.exam.scts.count - 1 else
        {
            return
        }
        
        currentSctIndex += 1
        
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
        // go to
        if segue.identifier == SctHorizontalViewController.toGoToSct,
            let destination = (segue.destination as? UINavigationController)?.viewControllers.first as? GoToSctViewController
        {
            destination.session = sctSession
            destination.currentSct = currentSctIndex
            destination.delegate = self
        }
        // image detail
        if segue.identifier == SctHorizontalViewController.toImageDetail,
            let target = segue.destination as? ImageDetailViewController,
            let image = detailImage_
        {
            target.image = image
            target.transitioningDelegate = target
        }
        // volume view
        if segue.identifier == SctHorizontalViewController.toVolume,
            let target = (segue.destination as? UINavigationController)?.viewControllers.first as? VolumeViewController,
            let volumeView = senderVolumeView_
        {
            target.scene = volumeView.scene
            target.transitioningDelegate = target
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - SCT QUESTION CELL DELEGATE
// -----------------------------------------------------------------------------
extension SctHorizontalViewController: SctQuestionCellDelegate
{
    public func sctQuestionCell(_ sctQuestionCell: SctQuestionCell, didSelectAnswer answer: LikertScale.Degree?)
    {
        let questionIndex = sctQuestionCell.tag
        sctSession[currentSctIndex, questionIndex] = answer
    }
}

// -----------------------------------------------------------------------------
// MARK: - NEW DATA DELEGATE
// -----------------------------------------------------------------------------
extension SctHorizontalViewController: NewDataDelegate
{
    public func newDataView(_ newDataView: NewDataView, didClickImageView imageView: UIImageView)
    {
        senderImageView = imageView
        performSegue(withIdentifier: SctHorizontalViewController.toImageDetail, sender: self)
    }
    
    public func newDataView(_ newDataView: NewDataView, didClickVolumeView scnView: SCNView)
    {
        senderVolumeView_ = scnView
        performSegue(withIdentifier: SctHorizontalViewController.toVolume, sender: self)
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
        currentSctIndex = sctIndex
    }
}
