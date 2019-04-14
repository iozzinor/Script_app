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
    static let toToothRecognitionSelection = "ToothRecognitionToToothRecognitionSelectionSegueId"
    
    @IBOutlet weak var monitoringLabel: UILabel!
    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var selectButton: UIButton!
    
    fileprivate var toothToRecognize_ = Tooth(internationalNumber: 11)
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        toothToRecognize_ = randomTooth_()
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
        setupSelectButton_()
    }
    
    fileprivate func setupMonitoringLabel_()
    {
        monitoringLabel.text = "ToothRecognition.FirstQuestion".localized
    }
    
    fileprivate func setupSelectButton_()
    {
        selectButton.setTitle("ToothRecognition.Select".localized, for: .normal)
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
    
    fileprivate func pickToothFile_() -> URL
    {
        return URL(string: "")!
        //Bundle.main.urls(forResourcesWithExtension: <#T##String?#>, subdirectory: <#T##String?#>)
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
        toothToRecognize_ = randomTooth_()
    }
}
