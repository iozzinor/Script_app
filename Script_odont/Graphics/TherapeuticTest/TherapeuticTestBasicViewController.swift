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
            ChooseScale.Graduation(title: "Absolument contre-indiqué", code: -2),
            ChooseScale.Graduation(title: "Contre-indiqué", code: -1),
            ChooseScale.Graduation(title: "Indiqué", code: 1),
            ChooseScale.Graduation(title: "Solution la plus indiquée", code: 2)
        
        ])
    
    public static let toImageDetail = "TherapeuticTestBasicToImageDetailSegueId"
    public static let toVolume      = "TherapeuticTestBasicToVolumeSegueId"
    
    enum SelectionMode
    {
        case single
        case scale(ChooseScale)
    }
    
    var selectionMode = SelectionMode.single
    
    var xRay: UIImage! {
        didSet {
            if isViewLoaded
            {
                xRayView.image = xRay
            }
        }
    }
    
    var stlToothUrl: URL! {
        didSet {
            if isViewLoaded
            {
                updateToothScene_()
            }
        }
    }
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var scaleLabel: UILabel!
    @IBOutlet weak var xRayView: UIImageView!
    @IBOutlet weak var toothView: SCNView!
    @IBOutlet weak var therapeuticChoicesView: UITableView!
    
    var previousItem: UIBarButtonItem!
    var timeItem: UIBarButtonItem!
    var nextItem: UIBarButtonItem!
    
    var questionsCount = 3
    
    fileprivate let therapeuticChoices_ = [
        "Composite",
        "Inlay",
        "Onlay",
        "Veneerlay / Overlay",
        "Endo-couronne",
        "Couronne"
    ]
    fileprivate var currentQuestion_ = 0
    fileprivate var userChoices_ = [[Int]]()
    fileprivate var scaleValues_: [Int] {
        switch selectionMode
        {
        case .single:
            return []
        case let .scale(scale):
            return scale.graduations.map { $0.code }
        }
    }
    fileprivate var timer_: Timer? = nil
    fileprivate var elapsedSeconds_ = 0
    fileprivate var elapsedTime_: Double = 0.0
    fileprivate var previousDate_ = Date()
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
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
        setupNavigationMenu_()
        setupNavigationButtons_()
        setupScaleLabel_()
        setupXRayImage_()
        setupToothVolume_()
        setupTherapeuticChoices_()
        setupUserChoices_()
    }
    
    fileprivate func setupNavigationMenu_()
    {
        previousItem = UIBarButtonItem(title: "Common.Previous".localized, style: .plain, target: self, action: #selector(TherapeuticTestBasicViewController.previousQuestion_))
        timeItem = UIBarButtonItem(title: "00:00", style: .plain, target: nil, action: nil)
        nextItem = UIBarButtonItem(title: "Common.Next".localized, style: .plain, target: self, action: #selector(TherapeuticTestBasicViewController.nextQuestion_))
        
        navigationItem.rightBarButtonItem = nextItem
        navigationItem.rightBarButtonItems?.append(timeItem)
        navigationItem.rightBarButtonItems?.append(previousItem)
        
        previousItem.isEnabled = false
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
    
    fileprivate func setupXRayImage_()
    {
        xRayView.image = xRay
        xRayView.backgroundColor = UIColor.black
        
        let touchRecognizer = UITapGestureRecognizer(target: self, action: #selector(TherapeuticTestBasicViewController.xRayTouched))
        touchRecognizer.numberOfTapsRequired = 1
        touchRecognizer.numberOfTouchesRequired = 1
        xRayView.addGestureRecognizer(touchRecognizer)
        xRayView.isUserInteractionEnabled = true
    }
    
    fileprivate func setupToothVolume_()
    {
        toothView.allowsCameraControl = true
        toothView.autoenablesDefaultLighting = true
        toothView.defaultCameraController.interactionMode = .orbitAngleMapping
        
        toothView.scene = SCNScene()
        toothView.scene?.background.contents = UIColor.black.cgColor
        
        // tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TherapeuticTestBasicViewController.toothVolumeTouched))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        toothView.addGestureRecognizer(tapGesture)
        
        updateToothScene_()
    }
    
    fileprivate func setupTherapeuticChoices_()
    {
        therapeuticChoicesView.registerNibCell(TherapeuticChoiceCell.self)
        therapeuticChoicesView.backgroundColor = UIColor.white
        
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
        userChoices_ = Array(repeating: defaultChoices, count: questionsCount)
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
        updateQuestionIndex_(currentQuestion_ - 1)
    }
    
    @IBAction func nextQuestion(_ button: UIButton)
    {
        updateQuestionIndex_(currentQuestion_ + 1)
    }
    
    @objc fileprivate func previousQuestion_()
    {
        updateQuestionIndex_(currentQuestion_ - 1)
    }
    
    
    @objc fileprivate func nextQuestion_()
    {
        updateQuestionIndex_(currentQuestion_ + 1)
    }
    
    @objc fileprivate func xRayTouched(_ tapGestureRecognizer: UITapGestureRecognizer)
    {
        performSegue(withIdentifier: TherapeuticTestBasicViewController.toImageDetail, sender: self)
    }
    
    @objc fileprivate func toothVolumeTouched(_ tapGestureRecognizer: UITapGestureRecognizer)
    {
        performSegue(withIdentifier: TherapeuticTestBasicViewController.toVolume, sender: self)
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
    
    fileprivate func updateToothScene_()
    {
        // clear nodes
        clearToothScene_()
        
        // attempt to add the node
        do
        {
            let node = try SCNNode.load(stlFileUrl: stlToothUrl)
            
            toothView.scene?.rootNode.addChildNode(node)
        }
        catch
        {
        }
    }
    
    fileprivate func updateQuestionIndex_(_ newIndex: Int)
    {
        currentQuestion_ = newIndex
        
        previousButton.isEnabled = currentQuestion_ > 0
        previousItem.isEnabled = previousButton.isEnabled
        nextButton.isEnabled = currentQuestion_ < questionsCount - 1
        nextItem.isEnabled = nextButton.isEnabled
        
        therapeuticChoicesView.reloadData()
        switch selectionMode
        {
        case .single:
            
            if userChoices_[currentQuestion_][0] > -1
            {
                therapeuticChoicesView.selectRow(at: IndexPath(row: userChoices_[currentQuestion_][0], section: 0), animated: false, scrollPosition: .none)
            }
        default:
            break
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUE
    // -------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == TherapeuticTestBasicViewController.toImageDetail,
            let target = segue.destination as? ImageDetailViewController
        {
            target.image = xRay
        }
        else if segue.identifier == TherapeuticTestBasicViewController.toVolume,
            let target = (segue.destination as? UINavigationController)?.viewControllers.first as? VolumeViewController
        {
            target.scene = toothView.scene
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
        switch selectionMode
        {
        case .single:
            if indexPath.row != userChoices_[currentQuestion_][0]
            {
                // update the selected answer
                if userChoices_[currentQuestion_][0] > -1
                {
                    let previousIndex = IndexPath(row: userChoices_[currentQuestion_][0], section: 0)
                    if let previousCell = therapeuticChoicesView.cellForRow(at: previousIndex)
                    {
                        previousCell.isSelected = false
                    }
                }
                
                userChoices_[currentQuestion_][0] = indexPath.row
                
                if let newCell = therapeuticChoicesView.cellForRow(at: indexPath)
                {
                    newCell.isSelected = true
                }
            }
            else
            {
                let previousIndex = IndexPath(row: userChoices_[currentQuestion_][0], section: 0)
                if let previousCell = therapeuticChoicesView.cellForRow(at: previousIndex)
                {
                    previousCell.isSelected = false
                }
                userChoices_[currentQuestion_][0] = -1
            }
        case .scale:
            break
        }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return therapeuticChoices_.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as TherapeuticChoiceCell
        cell.therapeuticLabel.text = therapeuticChoices_[indexPath.row]
        
        switch selectionMode
        {
        case .single:
            cell.isSelected = (indexPath.row == userChoices_[currentQuestion_][0])
        case .scale:
            cell.delegate = self
            cell.displayScales(scaleValues: scaleValues_, selected: userChoices_[currentQuestion_][indexPath.row], rowIndex: indexPath.row)
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
        userChoices_[currentQuestion_][rowIndex] = index;
    }
}
