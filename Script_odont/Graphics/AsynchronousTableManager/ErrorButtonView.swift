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
    fileprivate var stackView_: UIStackView!
    fileprivate var errorLabel_: UILabel!
    fileprivate var errorButton_: UIButton!
    
    fileprivate var error_: Error?
    
    weak var delegate: ErrorButtonDelegate?
    
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
    
    override func layoutSubviews()
    {
        errorButton_.layer.cornerRadius = errorButton_.frame.height / 2.0
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setup_()
    {
        setupStackView_()
        setupErrorLabel_()
        setupErrorButton_()
        
        stackView_.translatesAutoresizingMaskIntoConstraints = false
    }
    
    fileprivate func setupStackView_()
    {
        stackView_ = UIStackView()
        
        stackView_.alignment = .center
        stackView_.distribution = .fill
        stackView_.axis = .vertical
        stackView_.spacing = 20.0
        
        let centerX = NSLayoutConstraint(item: stackView_, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let centerY = NSLayoutConstraint(item: stackView_, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0)
        let left = NSLayoutConstraint(item: stackView_, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 5.0)
        let top = NSLayoutConstraint(item: stackView_, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        
        self.addSubview(stackView_)
        self.addConstraints([centerX, centerY, left, top])
    }
    
    fileprivate func setupErrorLabel_()
    {
        errorLabel_ = UILabel()
        
        errorLabel_.lineBreakMode = .byWordWrapping
        errorLabel_.numberOfLines = 0
        errorLabel_.textAlignment = .center
        errorLabel_.textColor = Appearance.Color.missing
        
        stackView_.addArrangedSubview(errorLabel_)
        
        let left = NSLayoutConstraint(item: errorLabel_, attribute: .left, relatedBy: .equal, toItem: stackView_, attribute: .left, multiplier: 1.0, constant: 0.0)
        stackView_.addConstraints([left])
    }
    
    fileprivate func setupErrorButton_()
    {
        errorButton_ = UIButton(type: .custom)
        errorButton_.setTitleColor(UIColor.gray, for: .normal)
        errorButton_.setTitleColor(UIColor.lightGray, for: .highlighted)
        errorButton_.layer.borderColor = UIColor.gray.cgColor
        errorButton_.layer.borderWidth = 2.0
        errorButton_.addTarget(self, action: #selector(ErrorButtonView.buttonClicked_), for: .touchUpInside)
        
        stackView_.addArrangedSubview(errorButton_)
    
        let left = NSLayoutConstraint(item: errorButton_, attribute: .left, relatedBy: .equal, toItem: stackView_, attribute: .left, multiplier: 1.0, constant: 0.0)
        stackView_.addConstraint(left)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @objc fileprivate func buttonClicked_(_ sender: UIButton)
    {
        guard error_ != nil else
        {
            return
        }
        
        delegate?.errorButtonView(self, actionTriggeredFor: error_!)
    }
}

// -----------------------------------------------------------------------------
// MARK: - ERROR DISPLAYER
// -----------------------------------------------------------------------------
extension ErrorButtonView: ErrorDisplayer
{
    func prepareFor(error: Error)
    {
        self.error_ = error
        updateLabelTitle_(forError: error)
        updateButton_(forError: error)
    }
    
    fileprivate func updateLabelTitle_(forError error: Error)
    {
        errorLabel_.text = error.localizedDescription
        errorLabel_.sizeToFit()
    }
    
    fileprivate func updateButton_(forError error: Error)
    {
        let displayErrorButton = delegate?.errorButtonView(shouldDisplayButton: self, error: error) ?? false
        errorButton_.isHidden = !displayErrorButton
        
        if displayErrorButton
        {
            let title = delegate?.errorButtonView(self, buttonTitleFor: error) ?? ""
            errorButton_.setTitle(title, for: .normal)
            errorButton_.setTitle(title, for: .selected)
        }
    }
}
