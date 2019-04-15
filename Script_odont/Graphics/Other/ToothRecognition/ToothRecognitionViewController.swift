//
//  ToothRecognitionViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 14/04/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit
import SceneKit
import ToothCommon

class ToothRecognitionViewController: UIViewController
{
    static let toToothRecognitionSelection  = "ToothRecognitionToToothRecognitionSelectionSegueId"
    static let toVolume                     = "ToothRecognitionToVolumeSegueId"
    
    @IBOutlet weak var monitoringLabel: UILabel!
    @IBOutlet weak var toothView: SCNView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate var toothToRecognize_ = Tooth(internationalNumber: 11)
    fileprivate var attempts_ = 0
    fileprivate var successes_ = 0
    
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
        
        navigationItem.title = "ToothRecognition.NavigationItem.Title".localized
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setup_()
    {
        setupMonitoringLabel_()
        setupToothScene_()
        setupSelectButton_()
        setupActivityIndicator_()
        
        pickTooth_()
    }
    
    fileprivate func setupMonitoringLabel_()
    {
        monitoringLabel.text = "ToothRecognition.FirstQuestion".localized
    }
    
    fileprivate func setupToothScene_()
    {
        // tooth view
        toothView.autoenablesDefaultLighting = true
        toothView.allowsCameraControl = true
        toothView.defaultCameraController.interactionMode = .orbitAngleMapping
        
        // scene
        let scene = SCNScene()
        scene.background.contents = UIColor.black
        toothView.scene = scene
        
        // gesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(ToothRecognitionViewController.toothViewTouched_))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.numberOfTouchesRequired = 1
        toothView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    fileprivate func setupSelectButton_()
    {
        selectButton.setTitle("ToothRecognition.Select".localized, for: .normal)
    }
    
    fileprivate func setupActivityIndicator_()
    {
        activityIndicator.color = UIColor.white
        
        view.bringSubviewToFront(activityIndicator)
        
        activityIndicator.isHidden = true
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UPDATE
    // -------------------------------------------------------------------------
    fileprivate func updateMonitoringLabel_()
    {
        monitoringLabel.text = String.localizedStringWithFormat("ToothRecognition.Monitoring".localized, successes_, attempts_)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - RANDOM TOOTH
    // -------------------------------------------------------------------------
    fileprivate func randomTooth_() -> Tooth
    {
        let quadrant = Constants.random(min: 1, max: 4)
        let position = Constants.random(min: 1, max: 8)
        
        let result = Tooth(internationalNumber: quadrant * 10 + position)
        return result
    }
    
    fileprivate func pickTooth_()
    {
        toothToRecognize_ = randomTooth_()
        
        let fileUrl = pickToothFile_()
        loadNode_(forUrl: fileUrl, completion: {
            (node, error) -> Void in
            
            DispatchQueue.main.async {
                if let node = node
                {
                    self.displayNode_(node)
                }
            }
        })
    }
    
    fileprivate func pickToothFile_() -> URL
    {
        return Bundle.main.url(forResource: "antagonist", withExtension: "stl", subdirectory: "SctData")!
    }
    
    fileprivate func loadNode_(forUrl url: URL, completion: ((SCNNode?, Error?) -> Void)?)
    {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        DispatchQueue.global(qos: .utility).async {
            do
            {
                let node = try SCNNode.load(stlFileUrl: url)
                completion?(node, nil)
            }
            catch
            {
               completion?(nil, error)
            }
        }
    }
    
    fileprivate func displayNode_(_ node: SCNNode)
    {
        // remove nodes
        if let childNodes = toothView.scene?.rootNode.childNodes
        {
            for childNode in childNodes
            {
                childNode.removeFromParentNode()
            }
        }
        
        // add the new one
        toothView.scene?.rootNode.addChildNode(node)
        
        // stop the activity indicator
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUE
    // -------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == ToothRecognitionViewController.toToothRecognitionSelection,
            let target = (segue.destination as? UINavigationController)?.viewControllers.first as? ToothRecognitionSelectionViewController
        {
            target.correctTooth = toothToRecognize_
            target.delegate = self
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @IBAction func displaySelection(_ sender: UIButton)
    {
        performSegue(withIdentifier: ToothRecognitionViewController.toToothRecognitionSelection, sender: self)
    }
    
    @objc fileprivate func toothViewTouched_(_ sender: UITapGestureRecognizer)
    {
        performSegue(withIdentifier: ToothRecognitionViewController.toVolume, sender: self)
    }
}

// -----------------------------------------------------------------------------
// MARK: - TOOTH RECOGNITION SELECTION DELEGATE
// -----------------------------------------------------------------------------
extension ToothRecognitionViewController: ToothRecognitionSelectionDelegate
{
    func toothRecognitionSelection(didCancel toothRecognitionSelection: ToothRecognitionSelectionViewController)
    {
    }
    
    func toothRecognitionSelection(_ toothRecognitionSelection: ToothRecognitionSelectionViewController, didSelect tooth: Tooth, correctTooth: Tooth)
    {
        attempts_ += 1
        if tooth == correctTooth
        {
            successes_ += 1
        }
        updateMonitoringLabel_()
        
        toothToRecognize_ = randomTooth_()
    }
}
