//
//  TestStlColorViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 21/05/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit
import SceneKit

class TestStlColorViewController: UIViewController
{
    @IBOutlet weak var sceneView: SCNView!
    
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
        setupSceneView_()
    }
    
    fileprivate func setupSceneView_()
    {
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.defaultCameraController.interactionMode = .orbitAngleMapping
        
        sceneView.scene = SCNScene()
        sceneView.scene?.background.contents = UIColor.black.cgColor
        
        guard let coloredSquareUrl = Bundle.main.url(forResource: "test_colored_square", withExtension: "stl") else
        {
            print("can not get url")
            return
        }
        print(coloredSquareUrl)
        
        // attempt to add the node
        do
        {
            let node = try SCNNode.load(stlFileUrl: coloredSquareUrl, meshOnly: false, parseColors: true)
            
            sceneView.scene?.rootNode.addChildNode(node)
        }
        catch
        {
        }
    }
}
