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
    var previousButton: UIBarButtonItem!
    var nextButton: UIBarButtonItem!
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var sceneView: SCNView!
    
    fileprivate var volumeUrls_: [URL]!
    fileprivate var currentVolume_ = 0
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        volumeUrls_ = Bundle.main.urls(forResourcesWithExtension: "stl", subdirectory: "TestColor") ?? []
        
        setup_()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setup_()
    {
        setupNavigationButtons_()
        updateNavigationButtons_()
        setupSceneView_()
    }
    
    fileprivate func setupNavigationButtons_()
    {
        previousButton = UIBarButtonItem(title: "Common.Previous".localized, style: .plain, target: self, action: #selector(TestStlColorViewController.previousVolume_))
        nextButton = UIBarButtonItem(title: "Common.Next".localized, style: .plain, target: self, action: #selector(TestStlColorViewController.nextVolume_))
        
        navigationItem.rightBarButtonItems = [nextButton, previousButton]
    }
    
    fileprivate func setupSceneView_()
    {
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.defaultCameraController.interactionMode = .orbitAngleMapping
        
        sceneView.scene = SCNScene()
        sceneView.scene?.background.contents = UIColor.white.cgColor
        
        displayVolume_()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @objc fileprivate func previousVolume_(_ sender: UIBarButtonItem)
    {
        updateCurrentVolume_(newVolume: currentVolume_ - 1)
    }
    
    @objc fileprivate func nextVolume_(_ sender: UIBarButtonItem)
    {
        updateCurrentVolume_(newVolume: currentVolume_ + 1)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UPDATE
    // -------------------------------------------------------------------------
    fileprivate func updateNavigationButtons_()
    {
        previousButton.isEnabled = currentVolume_ > 0
        nextButton.isEnabled = currentVolume_ < volumeUrls_.count - 1
    }
    
    fileprivate func updateCurrentVolume_(newVolume: Int)
    {
        currentVolume_ = newVolume
        updateNavigationButtons_()
        displayVolume_()
        displayFileName_()
    }
    
    fileprivate func displayVolume_()
    {
        clearNodes_()
        let volumeUrl = volumeUrls_[currentVolume_]
        addColoredNode_(volumeUrl: volumeUrl)
    }
    
    fileprivate func addColoredNode_(volumeUrl: URL)
    {
        // attempt to add the node
        do
        {
            let node = try SCNNode.load(stlFileUrl: volumeUrl, meshOnly: false, parseColors: true)
            
            sceneView.scene?.rootNode.addChildNode(node)
        }
        catch
        {
            print("can not load the node")
        }
    }
    
    fileprivate func clearNodes_()
    {
        guard let rootNode = sceneView.scene?.rootNode else
        {
            return
        }
        
        let currentNodes = rootNode.childNodes
        for node in currentNodes
        {
            node.removeFromParentNode()
        }
    }
    
    fileprivate func displayFileName_()
    {
        let volumeUrl = volumeUrls_[currentVolume_]
        fileNameLabel.text = volumeUrl.lastPathComponent
    }
}
