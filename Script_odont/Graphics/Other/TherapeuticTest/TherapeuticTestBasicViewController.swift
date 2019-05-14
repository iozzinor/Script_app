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
    public static let diagnosticScale = ChooseScale(meanings: [
            "Contre-indiqué",
            "Ni indiqué ni contre-indiqué",
            "Indiqué"
        ], start: -1, span: 1)
    
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
    
    @IBOutlet weak var xRayView: UIImageView!
    @IBOutlet weak var toothView: SCNView!
    @IBOutlet weak var therapeuticChoicesView: UITableView!
    
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    fileprivate let therapeuticChoices_ = [
        "Composite",
        "Inlay",
        "Onlay",
        "Couronne"
    ]
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setup_()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setup_()
    {
        setupXRayImage_()
        setupToothVolume_()
        setupTherapeuticChoices_()
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
        
        therapeuticChoicesView.dataSource = self
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
    
    @objc fileprivate func xRayTouched(_ tapGestureRecognizer: UITapGestureRecognizer)
    {
        performSegue(withIdentifier: TherapeuticTestBasicViewController.toImageDetail, sender: self)
    }
    
    @objc fileprivate func toothVolumeTouched(_ tapGestureRecognizer: UITapGestureRecognizer)
    {
         performSegue(withIdentifier: TherapeuticTestBasicViewController.toVolume, sender: self)
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
        
        return cell
    }
}
