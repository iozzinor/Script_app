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
        //scnView.scene = scene
        
        // temp add test node
        let verticesSource = SCNGeometrySource(vertices: [
            SCNVector3(0.0, 0.0, -1.0),
            SCNVector3(1.0, 0.0, -1.0),
            SCNVector3(0.0, 1.0, -1.0),
            SCNVector3(1.0, 1.0, -1.0)
            ])
        let indices: [Int16] = [0, 1, 2, 2, 1, 3]
        let verticesElement = SCNGeometryElement(indices: indices, primitiveType: .triangles)
        
        let normalsSource = SCNGeometrySource(normals: [
            SCNVector3(0.0, 0.0, 1.0),
            SCNVector3(0.0, 0.0, 1.0),
            SCNVector3(0.0, 0.0, 1.0),
            SCNVector3(0.0, 0.0, 1.0),
            SCNVector3(0.0, 0.0, 1.0),
            SCNVector3(0.0, 0.0, 1.0)
            ])
        let geometry = SCNGeometry(sources: [verticesSource, normalsSource], elements: [verticesElement])
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        material.isDoubleSided = true
        geometry.materials = [material, material]
        
        let newNode = SCNNode(geometry: geometry)
        
        scnView.scene = SCNScene()
        scnView.scene?.rootNode.addChildNode(newNode)
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        scnView.scene?.background.contents = UIColor.black
    }
    
    fileprivate func setupGestureRecognizer_()
    {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(VolumeViewController.viewTapped_))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTapsRequired = 1
        scnView.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func viewTapped_()
    {
        displayBar_ = !displayBar_
        navigationController?.navigationBar.isHidden = !displayBar_
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
