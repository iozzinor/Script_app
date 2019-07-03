//
//  TherapeuticTestBasicViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 12/05/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import SceneKit
import UIKit

class TherapeuticTestBasicViewController: UIViewController
{
    public static let diagnosticScale = ChooseScale(graduations: [
            ChooseScale.Graduation(title: "Fortement contre-indiqué", code: -2),
            ChooseScale.Graduation(title: "Pas indiqué", code: -1),
            ChooseScale.Graduation(title: "Indiqué", code: 1),
            ChooseScale.Graduation(title: "Le plus indiquée", code: 2)
        
        ])
    
    public static let toVolume          = "TherapeuticTestBasicToVolumeSegueId"
    public static let toCommentPicker   = "TherapeuticTestBasicToCommentPickerSegueId"
    
    public static let therapeuticLabelCellId = "TherapeuticLabelCellReuseId"
    
    enum SelectionMode
    {
        case single
        case scale(ChooseScale)
    }
    
    var selectionMode = SelectionMode.single
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var wordingLabel: UILabel!
    @IBOutlet weak var scaleLabel: UILabel!
    @IBOutlet weak var addCommentButton: UIButton!
    @IBOutlet weak var toothView: SCNView!
    @IBOutlet weak var therapeuticLabelsView: UITableView!
    @IBOutlet weak var therapeuticChoicesView: UITableView!
    
    var previousItem: UIBarButtonItem!
    var timeItem: UIBarButtonItem!
    var nextItem: UIBarButtonItem!
    var doneItem: UIBarButtonItem!
    var participant: TctParticipant! {
        didSet {
            if isViewLoaded
            {
                addCommentButton.isHidden = (participant.category != .teacher)
            }
        }
    }
    
    var sequenceIndex: Int = 0 {
        didSet {
            if sequenceIndex < 0 || sequenceIndex > TctQuestion.sequences.count - 1
            {
                sequenceIndex = oldValue
            }
            questions_ = TctQuestion.questions(sequenceIndex: sequenceIndex)
            
            if isViewLoaded
            {
                therapeuticChoicesView.reloadData()
                updateNavigationButtons_()
                setupUserChoices_()
            }
        }
    }
    
    fileprivate var questions_: [TctQuestion] = []
    fileprivate var sessionId_: Int? = nil
    
    fileprivate let therapeuticChoices_ = [
        "TherapeuticTest.Choice.Composite".localized,
        "TherapeuticTest.Choice.InlayOnlay".localized,
        "TherapeuticTest.Choice.VeneerlayOverlay".localized,
        "TherapeuticTest.Choice.EndocrownLutedCrown".localized,
        "TherapeuticTest.Choice.CrrSealedCrown".localized
    ]
    fileprivate var currentQuestionIndex_ = 0
    fileprivate var currentQuestion_: TctQuestion {
        return questions_[questionsSuffleIndexes_[currentQuestionIndex_]]
    }
    fileprivate var questionsSuffleIndexes_ = [Int]()
    fileprivate var userChoices_ = [[Int]]()
    fileprivate var comments_ = [String]()
    fileprivate var scaleValues_: [Int] {
        switch selectionMode
        {
        case .single:
            return []
        case let .scale(scale):
            return scale.graduations.map { $0.code }
        }
    }
    fileprivate var stlToothUrl_: URL? {
        let currentFileName = questions_[questionsSuffleIndexes_[currentQuestionIndex_]].volumeFileName
        return Bundle.main.url(forResource: currentFileName, withExtension: "stl", subdirectory: "TherapeuticChoiceTraining")
    }
    fileprivate var timer_: Timer? = nil
    fileprivate var elapsedSeconds_ = 0
    fileprivate var elapsedTime_: Double = 0.0
    fileprivate var previousDate_ = Date()
    
    // -------------------------------------------------------------------------
    // MARK: - DEVICE ORIENTATION
    // -------------------------------------------------------------------------
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    @objc fileprivate func deviceDidChangeOrientation_(_ newOrientation: UIInterfaceOrientation)
    {
        therapeuticLabelsView.reloadData()
        therapeuticChoicesView.reloadData()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setup_()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        createTimer_()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        destroyTimer_()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setup_()
    {
        // navigation bar
        setupNavigationMenu_()
        setupNavigationButtons_()
        
        therapeuticChoicesView.reloadData()
        updateNavigationButtons_()
        
        // views
        setupUserChoices_()
        setupScaleLabel_()
        setupAddCommentButton_()
        setupToothVolume_()
        setupTherapeuticLabels_()
        setupTherapeuticChoices_()
        updateWording_()
        
        // session
        setupSession_()
        
        // device orientation notifier
        NotificationCenter.default.addObserver(self, selector: #selector(TherapeuticTestBasicViewController.deviceDidChangeOrientation_), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    fileprivate func setupNavigationMenu_()
    {
        previousItem = UIBarButtonItem(title: "Common.Previous".localized, style: .plain, target: self, action: #selector(TherapeuticTestBasicViewController.previousQuestion_))
        timeItem = UIBarButtonItem(title: "00:00", style: .plain, target: nil, action: nil)
        nextItem = UIBarButtonItem(title: "Common.Next".localized, style: .plain, target: self, action: #selector(TherapeuticTestBasicViewController.nextQuestion_))
        doneItem = UIBarButtonItem(title: "TherapeuticTest.Finish".localized, style: .plain, target: self, action: #selector(TherapeuticTestBasicViewController.displayFinishDialog_))
        
        navigationItem.rightBarButtonItem = doneItem
        navigationItem.rightBarButtonItems?.append(nextItem)
        navigationItem.rightBarButtonItems?.append(timeItem)
        navigationItem.rightBarButtonItems?.append(previousItem)
        
        updateNavigationButtons_()
        timeItem.isEnabled = false
    }
    
    fileprivate func setupNavigationButtons_()
    {
        let arrowPrevious = UIImage(named: "arrow_previous")
        let previousSelectedImage = arrowPrevious?.createImage(usingColor: UIColor.blue)
        let previousDisabledImage = arrowPrevious?.createImage(usingColor: UIColor.gray)
        
        let arrowNext = UIImage(named: "arrow_next")
        let nextSelectedImage = arrowNext?.createImage(usingColor: UIColor.blue)
        let nextDisabledImage = arrowNext?.createImage(usingColor: UIColor.gray)
        
        previousButton.setImage(previousSelectedImage, for: .normal)
        previousButton.setImage(previousDisabledImage, for: .disabled)
        previousButton.isEnabled = false
        
        nextButton.setImage(nextSelectedImage, for: .normal)
        nextButton.setImage(nextDisabledImage, for: .disabled)
    }
    
    fileprivate func setupScaleLabel_()
    {
        switch selectionMode
        {
        case .single:
            scaleLabel.isHidden = true
        case let .scale(scale):
            var scaleText = ""
            for graduation in scale.graduations
            {
                if !scaleText.isEmpty
                {
                    scaleText += " | "
                }
                scaleText += "\(graduation.code): \(graduation.title)"
            }
            scaleLabel.text = scaleText
        }
    }
    
    fileprivate func setupAddCommentButton_()
    {
        addCommentButton.isHidden = participant.category != .teacher
        addCommentButton.setTitle("TherapeuticTest.AddCommentButton".localized, for: .normal)
        addCommentButton.addTarget(self, action: #selector(TherapeuticTestBasicViewController.addComment_), for: .touchUpInside)
    }
    
    fileprivate func setupToothVolume_()
    {
        toothView.allowsCameraControl = true
        toothView.autoenablesDefaultLighting = true
        toothView.defaultCameraController.interactionMode = .orbitAngleMapping
        
        toothView.scene = SCNScene()
        
        // make the background white
        toothView.scene?.background.contents = UIColor.white.cgColor
        
        // make the border black
        toothView.addBorders(with: UIColor.black, lineWidth: 1, positions: [.top, .bottom, .right, .left])
        
        // tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TherapeuticTestBasicViewController.toothVolumeTouched))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        toothView.addGestureRecognizer(tapGesture)
        
        updateToothScene_()
    }
    
    fileprivate func setupTherapeuticLabels_()
    {
        therapeuticLabelsView.isScrollEnabled = false
        
        therapeuticLabelsView.delegate = self
        therapeuticLabelsView.dataSource = self
    }
    
    fileprivate func setupTherapeuticChoices_()
    {
        switch selectionMode
        {
        case .single:
            therapeuticChoicesView.isHidden = true
            return
        case .scale(_):
            break
        }
        
        therapeuticChoicesView.isScrollEnabled = false
        therapeuticChoicesView.registerNibCell(TherapeuticChoiceCell.self)
        
        therapeuticChoicesView.delegate = self
        therapeuticChoicesView.dataSource = self
    }
    
    fileprivate func setupUserChoices_()
    {
        let choicePossibilities: Int
        switch selectionMode
        {
        case .single:
            choicePossibilities = 1
        case .scale:
            choicePossibilities = therapeuticChoices_.count
        }
        
        let defaultChoices = Array<Int>(repeating: -1, count: choicePossibilities)
        userChoices_ = Array(repeating: defaultChoices, count: questions_.count)
        
        comments_ = Array(repeating: "", count: questions_.count)
        
        updateQuestionsMapping_()
    }
    
    fileprivate func setupSession_()
    {
        guard let id = sessionId_ else
        {
            return
        }
        
        if let session = TctSaver.getSession(for: sequenceIndex, id: id),
            questionsSuffleIndexes_.count > 0
        {
            for questionIndex in 0..<session.answers.count
            {
                let shuffledIndex = questionsSuffleIndexes_[questionIndex]
                
                userChoices_[questionIndex] = session.answers[shuffledIndex]
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - TIMER
    // -------------------------------------------------------------------------
    fileprivate func createTimer_()
    {
        timer_ = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(TherapeuticTestBasicViewController.updateTime_), userInfo: nil, repeats: true)
    }
    
    fileprivate func destroyTimer_()
    {
        timer_?.invalidate()
        timer_ = nil
    }
    
    @objc fileprivate func updateTime_()
    {
        elapsedTime_ += -previousDate_.timeIntervalSinceNow
        previousDate_ = Date()
        
        let newDisplayedTime = Int(floor(elapsedTime_))
        
        if newDisplayedTime > elapsedSeconds_
        {
            elapsedSeconds_ = newDisplayedTime
            
            // refresh the displayed time
            let minutes = newDisplayedTime / 60
            let seconds = newDisplayedTime % 60
            
            let timeTitle = String(format: "%02d:%02d", minutes, seconds)
            
            timeItem.title = timeTitle
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @IBAction func previousQuestion(_ button: UIButton)
    {
        updateQuestionIndex_(currentQuestionIndex_ - 1)
    }
    
    @IBAction func nextQuestion(_ button: UIButton)
    {
        updateQuestionIndex_(currentQuestionIndex_ + 1)
    }
    
    @objc fileprivate func previousQuestion_()
    {
        updateQuestionIndex_(currentQuestionIndex_ - 1)
    }
    
    @objc fileprivate func nextQuestion_()
    {
        updateQuestionIndex_(currentQuestionIndex_ + 1)
    }
    
    @objc fileprivate func addComment_(_ sender: UIButton)
    {
        performSegue(withIdentifier: TherapeuticTestBasicViewController.toCommentPicker, sender: self)
    }
    
    @objc fileprivate func toothVolumeTouched(_ tapGestureRecognizer: UITapGestureRecognizer)
    {
        performSegue(withIdentifier: TherapeuticTestBasicViewController.toVolume, sender: self)
    }
    
    @objc fileprivate func displayFinishDialog_()
    {
        let finishDialog = UIAlertController(title: "TherapeuticTest.FinishDialog.Title".localized, message: "TherapeuticTest.FinishDialog.Message".localized, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Common.Cancel".localized, style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "TherapeuticTest.Finish".localized, style: .default, handler: {
            (UIAlertAction) -> Void in
            self.saveSession_()
        })
        
        finishDialog.addAction(cancelAction)
        finishDialog.addAction(saveAction)
        
        present(finishDialog, animated: true, completion: nil)
    }
    
    fileprivate func saveSession_()
    {
        // get the answers, and the comments
        var answers = Array<Array<Int>>(repeating: [], count: userChoices_.count)
        var comments = Array<String>(repeating: "", count: questions_.count)
        for (i, index) in questionsSuffleIndexes_.enumerated()
        {
            answers[i] = userChoices_[index]
            comments[i] = comments_[index]
        }
        
        // save the session
        let session: TctSession
        switch participant.category
        {
        case .teacher:
            session = TctSession(sequenceIndex: sequenceIndex, date: Date(), participant: participant, answers: answers, comments: comments)
        case .intern, .student4, .student5, .student6:
            session = TctSession(sequenceIndex: sequenceIndex, date: Date(), participant: participant, answers: answers)
        }
        
        TctSaver.save(session: session, sequenceIndex: sequenceIndex)
        
        // display the success message
        displaySaveSuccess_()
    }
    
    fileprivate func displaySaveSuccess_()
    {
        let successDialog = UIAlertController(title: "TherapeuticChoice.SaveSuccessDialog.Title".localized, message: "TherapeuticChoice.SaveSuccessDialog.Message".localized, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Common.Ok".localized, style: .default, handler: {
            UIAlertAction -> Void in
            
            self.saveDialogClosed_()
        })
        successDialog.addAction(okAction)
        
        present(successDialog, animated: true, completion: nil)
    }
    
    fileprivate func saveDialogClosed_()
    {
        navigationController?.popViewController(animated: true)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UPDATE
    // -------------------------------------------------------------------------
    fileprivate func clearToothScene_()
    {
        guard let rootNode = toothView.scene?.rootNode else
        {
            return
        }
        
        let childrenCount = rootNode.childNodes.count
        for i in 0..<rootNode.childNodes.count
        {
            let index = childrenCount - i - 1
            let node = rootNode.childNodes[index]
            node.removeFromParentNode()
        }
    }
    
    fileprivate func updateWording_()
    {
        let questionIndex = TctQuestion.sequences[sequenceIndex][questionsSuffleIndexes_[currentQuestionIndex_]]
        wordingLabel.text = "\(questionIndex + 1). " + currentQuestion_.wording
        wordingLabel.text = currentQuestion_.wording
    }
    
    fileprivate func updateToothScene_()
    {
        // clear nodes
        clearToothScene_()
        
        guard let volumeUrl = stlToothUrl_ else
        {
            return
        }
        
        // attempt to add the node
        do
        {
            let node = try SCNNode.load(stlFileUrl: volumeUrl)
            
            toothView.scene?.rootNode.addChildNode(node)
            
            // update the camera
            let (minimum, maximum) = node.boundingBox
            let maxLength = max(max(abs(maximum.x - minimum.x), abs(maximum.y - minimum.y)), abs(maximum.z - minimum.z))
            toothView.defaultCameraController.pointOfView?.position = SCNVector3(0, 0, maxLength * 1.5)
            toothView.defaultCameraController.pointOfView?.look(at: SCNVector3(0, 0, 0), up: SCNVector3(0, 1, 0), localFront: SCNVector3(0, 0, -1))
        }
        catch
        {
        }
    }
    
    fileprivate func updateNavigationButtons_()
    {
        previousButton.isEnabled = currentQuestionIndex_ > 0
        previousItem.isEnabled = previousButton.isEnabled
        nextButton.isEnabled = currentQuestionIndex_ < questions_.count - 1
        nextItem.isEnabled = nextButton.isEnabled
    }
    
    fileprivate func updateQuestionIndex_(_ newIndex: Int)
    {
        currentQuestionIndex_ = newIndex
        
        updateWording_()
        updateNavigationButtons_()
        updateToothScene_()
        
        therapeuticChoicesView.reloadData()
        switch selectionMode
        {
        case .single:
            
            if userChoices_[currentQuestionIndex_][0] > -1
            {
                therapeuticChoicesView.selectRow(at: IndexPath(row: userChoices_[currentQuestionIndex_][0], section: 0), animated: false, scrollPosition: .none)
            }
        default:
            break
        }
    }
    
    fileprivate func updateQuestionsMapping_()
    {
        // shuffle the questions array
        // to make the order random
        questionsSuffleIndexes_ = Array<Int>(repeating: -1, count: questions_.count)
        for i in 0..<questions_.count
        {
            questionsSuffleIndexes_[i] = i
        }
        
        questionsSuffleIndexes_.shuffle()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UTILS
    // -------------------------------------------------------------------------
    func loadSession(withId id: Int)
    {
        sessionId_ = id
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUE
    // -------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // TO VOLUME
        if segue.identifier == TherapeuticTestBasicViewController.toVolume,
            let target = (segue.destination as? UINavigationController)?.viewControllers.first as? VolumeViewController
        {
            target.scene = toothView.scene
        }
        // TO COMMENT PICKER
        else if segue.identifier == TherapeuticTestBasicViewController.toCommentPicker,
            let target = segue.destination as? CommentPickerViewController
        {
            target.comment  = comments_[currentQuestionIndex_]
            target.delegate = self
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - UI TABLE VIEW DELEGATE
// -----------------------------------------------------------------------------
extension TherapeuticTestBasicViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        if tableView == therapeuticLabelsView
        {
            return nil
        }
        
        switch selectionMode
        {
        case .single:
            return indexPath
        case .scale:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView == therapeuticChoicesView
        {
            return
        }
        
        switch selectionMode
        {
        case .single:
            if indexPath.row != userChoices_[currentQuestionIndex_][0]
            {
                // update the selected answer
                if userChoices_[currentQuestionIndex_][0] > -1
                {
                    let previousIndex = IndexPath(row: userChoices_[currentQuestionIndex_][0], section: 0)
                    if let previousCell = therapeuticChoicesView.cellForRow(at: previousIndex)
                    {
                        previousCell.isSelected = false
                    }
                }
                
                userChoices_[currentQuestionIndex_][0] = indexPath.row
                
                if let newCell = therapeuticChoicesView.cellForRow(at: indexPath)
                {
                    newCell.isSelected = true
                }
            }
            else
            {
                let previousIndex = IndexPath(row: userChoices_[currentQuestionIndex_][0], section: 0)
                if let previousCell = therapeuticChoicesView.cellForRow(at: previousIndex)
                {
                    previousCell.isSelected = false
                }
                userChoices_[currentQuestionIndex_][0] = -1
            }
        case .scale:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return toothView.frame.height / CGFloat(therapeuticChoices_.count)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0.0
    }
}

// -----------------------------------------------------------------------------
// MARK: - UI TABLE VIEW DATA SOURCE
// -----------------------------------------------------------------------------
extension TherapeuticTestBasicViewController: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return therapeuticChoices_.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == therapeuticLabelsView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: TherapeuticTestBasicViewController.therapeuticLabelCellId, for: indexPath)
            
            cell.textLabel?.text = therapeuticChoices_[indexPath.row]
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(for: indexPath) as TherapeuticChoiceCell
        
        switch selectionMode
        {
        case .single:
            cell.isSelected = (indexPath.row == userChoices_[currentQuestionIndex_][0])
        case .scale:
            cell.delegate = self
            cell.displayScales(scaleValues: scaleValues_, selected: userChoices_[currentQuestionIndex_][indexPath.row], rowIndex: indexPath.row)
        }
        
        return cell
    }
}

// -----------------------------------------------------------------------------
// MARK: - THERAPEUTIC CHOICE DELEGATE
// -----------------------------------------------------------------------------
extension TherapeuticTestBasicViewController: TherapeuticChoiceDelegate
{
    func didSelectValue(at index: Int, for rowIndex: Int)
    {
        userChoices_[currentQuestionIndex_][rowIndex] = index;
    }
}

// -----------------------------------------------------------------------------
// MARK: - COMMENT PICKER DELEGATE
// -----------------------------------------------------------------------------
extension TherapeuticTestBasicViewController: CommentPickerDelegate
{
    func commentPickerViewController(didCancel commentPickerViewController: CommentPickerViewController)
    {
    }
    
    func commentPickerViewController(_ commentPickerViewController: CommentPickerViewController, didPickComment comment: String)
    {
        self.comments_[currentQuestionIndex_] = comment
    }
}
