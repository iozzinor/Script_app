//
//  VolumeViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 29/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit
import SceneKit

class VolumeViewController: UIViewController
{
    @IBOutlet weak var toggleMeshButton: UIBarButtonItem!
    
    fileprivate var displayBar_ = false
    
    var scene: SCNScene! {
        didSet {
            if isViewLoaded
            {
                scnView.scene = scene
            }
        }
    }
    var scnView: SCNView!
    fileprivate var displayMesh_ = true
    fileprivate var meshNode_: SCNNode? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        setup_()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setup_()
    {
        setupScene_()
        setupGestureRecognizer_()
    }
    
    fileprivate func setupScene_()
    {
        if let sceneView = view as? SCNView
        {
            self.scnView = sceneView
        }
        scnView.scene = scene
        
        scnView.autoenablesDefaultLighting = true
        scnView.allowsCameraControl = true
        scnView.showsStatistics = true
        scnView.defaultCameraController.interactionMode = .orbitAngleMapping
        
        if scene.rootNode.childNodes.count > 1
        {
            meshNode_ = scene.rootNode.childNodes[1]
        }
    }
    
    fileprivate func setupGestureRecognizer_()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(VolumeViewController.viewTapped_))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTapsRequired = 1
        scnView.addGestureRecognizer(tapGesture)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @IBAction func cancel(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func viewTapped_()
    {
        displayBar_ = !displayBar_
        navigationController?.navigationBar.isHidden = !displayBar_
    }
    
    @IBAction func toggleMesh(_ sender: UIBarButtonItem)
    {
        displayMesh_ = !displayMesh_
        
        if displayMesh_,
            let mesh = meshNode_
        {
            scene.rootNode.addChildNode(mesh)
            
            toggleMeshButton.title = "Hide mesh"
        }
        else
        {
            meshNode_?.removeFromParentNode()
            
            toggleMeshButton.title = "Display mesh"
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - UI VIEW CONTROLLER TRANSITIONING DELEGATE
// -----------------------------------------------------------------------------
extension VolumeViewController: UIViewControllerTransitioningDelegate
{
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return ImageFadeOutAnimationController()
    }
}
