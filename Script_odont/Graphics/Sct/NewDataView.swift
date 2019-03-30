//
//  NewDataView.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit
import SceneKit

extension SctData.Content
{
    var caseName: String
    {
        let name = "\(self)"
        return name.replacingOccurrences(of: "[(][^)]+[)]", with: "", options: .regularExpression, range: nil)
    }
}

public class NewDataView: UIView
{
    fileprivate var previousContent_ = SctData.Content.text("")
    fileprivate var currentDataView_: UIView? = nil
    {
        didSet
        {
            currentDataView_?.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    var questionData = SctData()
    {
        didSet
        {
            updateView_(forData: questionData)
        }
    }
    
    weak var delegate: NewDataDelegate? = nil
    
    var label: UILabel? {
        return currentDataView_ as? UILabel
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setupView_(forData data: SctData)
    {
        switch data.content
        {
        case let .text(text):
            setupLabel_(forText: text)
        case let .image(image):
            setupImageView_(forImage: image)
        case let .volume(fileName):
            setupVolumeView_(forFileName: fileName)
        }
    }
    
    fileprivate func setupLabel_(forText text: String)
    {
        let newDataLabel = UILabel()
        newDataLabel.numberOfLines = 0
        newDataLabel.lineBreakMode = .byWordWrapping
        
        self.addSubviewAdjusting(newDataLabel)
        currentDataView_ = newDataLabel
        
        refreshLabel_(forText: text)
    }
    
    fileprivate func setupImageView_(forImage image: UIImage)
    {
        let newDataImageView = UIImageView()
        self.addSubviewAdjusting(newDataImageView)
        
        // touch listener
        let newDataImageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewDataView.imageViewTapped_))
        newDataImageGestureRecognizer.numberOfTapsRequired = 1
        newDataImageGestureRecognizer.numberOfTouchesRequired = 1
        newDataImageView.gestureRecognizers?.removeAll()
        newDataImageView.addGestureRecognizer(newDataImageGestureRecognizer)
        newDataImageView.isUserInteractionEnabled = true
        newDataImageView.contentMode = .scaleAspectFit
        
        currentDataView_ = newDataImageView
        
        refreshImageView_(forImage: image)
    }
    
    fileprivate func setupVolumeView_(forFileName fileName: String)
    {
        let newVolumeView = SCNView()
        self.addSubviewAdjusting(newVolumeView)
        
        newVolumeView.autoenablesDefaultLighting = true
        newVolumeView.allowsCameraControl = true
        
        // default scene
        let scene = SCNScene()
        scene.background.contents = UIColor.black
        newVolumeView.scene = scene
        
        currentDataView_ = newVolumeView
        
        // touch listener
        let touchGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewDataView.volumeViewTapped_))
        touchGestureRecognizer.numberOfTapsRequired = 1
        touchGestureRecognizer.numberOfTouchesRequired = 1
        newVolumeView.addGestureRecognizer(touchGestureRecognizer)
        
        refreshVolumeView_(forFileName: fileName)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UPDATE
    // -------------------------------------------------------------------------
    fileprivate func updateView_(forData data: SctData)
    {
        if currentDataView_ != nil
        {
            if data.content.caseName == previousContent_.caseName
            {
                refreshView_(forData: data)
            }
            else
            {
                currentDataView_!.removeFromSuperview()
                currentDataView_ = nil
            }
        }
        if currentDataView_ == nil
        {
            setupView_(forData: data)
        }
        previousContent_ = data.content
    }
    
    // -------------------------------------------------------------------------
    // MARK: - REFRESH
    // -------------------------------------------------------------------------
    fileprivate func refreshView_(forData data: SctData)
    {
        switch data.content
        {
        case let .text(text):
            refreshLabel_(forText: text)
        case let .image(image):
            refreshImageView_(forImage: image)
        case let .volume(fileName):
            refreshVolumeView_(forFileName: fileName)
        }
    }
    
    fileprivate func refreshLabel_(forText text: String)
    {
        if let label = currentDataView_ as? UILabel
        {
            label.text = text
        }
    }
    
    fileprivate func refreshImageView_(forImage image: UIImage)
    {
        if let imageView = currentDataView_ as? UIImageView
        {
            imageView.image = image
        }
    }
    
    fileprivate func refreshVolumeView_(forFileName fileName: String)
    {
        if let volumeView = currentDataView_ as? SCNView
        {
            guard let cubePath = Bundle.main.path(forResource: "simple_cube", ofType: "stl") else
            {
                return
            }
            
            volumeView.scene?.background.contents = UIColor.black
            if let node = SCNNode.fromStlFile(filePath: cubePath)
            {
                volumeView.scene?.rootNode.addChildNode(node)
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTION
    // -------------------------------------------------------------------------
    @objc fileprivate func imageViewTapped_(sender: UITapGestureRecognizer)
    {
        if let imageView = currentDataView_ as? UIImageView
        {
            delegate?.newDataView(self, didClickImageView: imageView)
        }
    }
    
    @objc fileprivate func volumeViewTapped_(sender: UITapGestureRecognizer)
    {
        if let volumeView = currentDataView_ as? SCNView
        {
            delegate?.newDataView(self, didClickVolumeView: volumeView)
        }
    }
}
