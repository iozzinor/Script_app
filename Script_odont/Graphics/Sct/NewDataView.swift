//
//  NewDataView.swift
//  Script_odont
//
//  Created by Régis Iozzino on 28/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

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
}
