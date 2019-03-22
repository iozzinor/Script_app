//
//  ErrorButtonView.swift
//  Script_odont
//
//  Created by Régis Iozzino on 20/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class ErrorButtonView: UIView
{
    fileprivate var errorLabel_: UILabel!
    fileprivate var errorButton_: UIButton!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setup_()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        setup_()
    }
    
    // -----------------------------------------------------------------------------
    // MARK: - SETUP
    // -----------------------------------------------------------------------------
    fileprivate func setup_()
    {
        setupErrorLabel_()
    }
    
    fileprivate func setupErrorLabel_()
    {
        errorLabel_ = UILabel()
        errorLabel_.translatesAutoresizingMaskIntoConstraints = false
        errorLabel_.lineBreakMode = .byWordWrapping
        errorLabel_.numberOfLines = 0
        
        let left = NSLayoutConstraint(item: errorLabel_, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 5.0)
        let centerX = NSLayoutConstraint(item: errorLabel_, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let top = NSLayoutConstraint(item: errorLabel_, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: -5.0)
        let centerY = NSLayoutConstraint(item: errorLabel_, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        
        self.addSubview(errorLabel_)
        self.addConstraints([left, centerX, top, centerY])
    }
}

// -----------------------------------------------------------------------------
// MARK: - ERROR DISPLAYER
// -----------------------------------------------------------------------------
extension ErrorButtonView: ErrorDisplayer
{
    func prepareFor(error: Error)
    {
        errorLabel_.text = error.localizedDescription
        errorLabel_.sizeToFit()
    }
}
