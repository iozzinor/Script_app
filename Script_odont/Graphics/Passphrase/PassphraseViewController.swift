//
//  PassphraseViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class PassphraseViewController: UIViewController
{
    enum EditType
    {
        case create
        case modify
    }
    
    enum Step
    {
        case createPassphrase
        case confirmation
        
        case previousPassphrase
        case newPassphrase
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var passphraseView: UIView!
    @IBOutlet weak var optionsButton: UIButton!
    
    var previousPassphrase = Passphrase()
    var passphrase = Passphrase()
    
    fileprivate var passphraseControls_ = [Passphrase.Kind: UIControl]()
    fileprivate var passphraseControl_: UIControl?
    {
        didSet
        {
            if passphraseControl_ != oldValue
            {
                oldValue?.removeFromSuperview()
                
                if let newPassphraseControl = passphraseControl_
                {
                    passphraseView.addSubview(newPassphraseControl)
                    passphraseView.adjustSubview(newPassphraseControl)
                    newPassphraseControl.becomeFirstResponder()
                }
            }
        }
    }
    fileprivate var currentPassphraseKind_ = Passphrase.Kind.sixDigitCode
    {
        didSet
        {
            self.passphraseControl_ = self.passphraseControls_[currentPassphraseKind_]
        }
    }
    
    var editType = EditType.create {
        didSet {
            switch editType
            {
            case .create:
                step_ = .createPassphrase
            case .modify:
                step_ = .previousPassphrase
            }
            
            if isViewLoaded
            {
                updateView_()
            }
        }
    }
    fileprivate var step_ = Step.createPassphrase
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setup_()
        optionsButton.addTarget(self, action: #selector(PassphraseViewController.optionsButtonTapped_), for: .touchUpInside)
        updateView_()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setup_()
    {
        setupPassphraseControls_()
        passphraseControl_ = passphraseControls_[.sixDigitCode]
    }
    
    fileprivate func setupPassphraseControls_()
    {
        let numericPassphraseControl = NumericPassphraseControl()
        numericPassphraseControl.delegate = self
        passphraseControls_[.sixDigitCode] = numericPassphraseControl
        
        let phraseTextField = UITextField()
        phraseTextField.textContentType = UITextContentType.password
        phraseTextField.delegate = self
        passphraseControls_[.phrase] = phraseTextField
        
        for passphraseControl in passphraseControls_.values
        {
            passphraseControl.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    fileprivate func updateView_()
    {
        optionsButton.setTitle("Passphrase Options", for: .normal)
        optionsButton.isHidden = false
        switch step_
        {
        case .createPassphrase:
            titleLabel.text = "Passphrase Creation"
            instructionLabel.text = "Enter the new passcode."
            optionsButton.setTitle("Passphrase Options", for: .normal)
        case .newPassphrase:
            instructionLabel.text = "Enter the new passcode."
            optionsButton.setTitle("Passphrase Options", for: .normal)
        case .previousPassphrase:
            titleLabel.text = "Passphrase Modification"
            instructionLabel.text = "Enter the previous passcode."
            
            optionsButton.isHidden = true
            
        case .confirmation:
            instructionLabel.text = "Confirm the passcode."
            
            optionsButton.setTitle("Common.Cancel".localized, for: .normal)
        }
    }
    
    fileprivate func canAdvanceStep_(enteredPassphrase: String) -> Bool
    {
        switch step_
        {
        case .createPassphrase, .newPassphrase:
            return true
        case .previousPassphrase:
            return previousPassphrase.text == enteredPassphrase
        case .confirmation:
            return passphrase.text == enteredPassphrase
        }
    }
    
    fileprivate func nextStep_(enteredPassphrase: String)
    {
        switch step_
        {
        case .createPassphrase, .newPassphrase:
            passphrase = Passphrase(kind: currentPassphraseKind_, text: enteredPassphrase)
            step_ = .confirmation
        case .previousPassphrase:
            step_ = .createPassphrase
        case .confirmation:
            dismiss(animated: true, completion: nil)
        }
        
        updateView_()
    }
    
    @objc fileprivate func optionsButtonTapped_(_ sender: UIButton)
    {
        switch step_
        {
        case .confirmation:
            cancelConfirmation_()
        case .createPassphrase, .newPassphrase:
            displayPassphraseOptions_()
        case .previousPassphrase:
            break
        }
    }
    
    fileprivate func cancelConfirmation_()
    {
        switch editType
        {
        case .create:
            step_ = .createPassphrase
        case .modify:
            step_ = .newPassphrase
        }
        updateView_()
    }
    
    fileprivate func displayPassphraseOptions_()
    {
        let passphraseController = UIAlertController(title: "Passphrase Options", message: "Choose a passphrase kind.", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Common.Cancel".localized, style: .cancel, handler: nil)
        
        passphraseController.addAction(cancelAction)
        
        // add choose passphrase kind actions
        for passphraseKind in passphraseControls_.keys
        {
            let newChooseKindAction = getChoosePassphraseKindAction_(kind: passphraseKind)
            passphraseController.addAction(newChooseKindAction)
        }
        
        present(passphraseController, animated: true, completion: nil)
    }
    
    fileprivate func getChoosePassphraseKindAction_(kind: Passphrase.Kind) -> UIAlertAction
    {
        return UIAlertAction(title: kind.name, style: .default, handler: {
            (_) -> Void in
            
            self.currentPassphraseKind_ = kind
        })
    }
}

// -----------------------------------------------------------------------------
// MARK: - TEXT FIELD DELEGATE
// -----------------------------------------------------------------------------
extension PassphraseViewController: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let newString = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string) as String
        
        switch currentPassphraseKind_
        {
        case .phrase:
            break
        case .sixDigitCode:
            
            if newString.count == 6
            {
                if canAdvanceStep_(enteredPassphrase: newString)
                {
                    nextStep_(enteredPassphrase: newString)
                }
                else
                {
                    // show the error
                    textField.transform = CGAffineTransform(translationX: 10, y: 0)
                    
                    UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 4.0, options: [], animations: {
                        textField.transform = CGAffineTransform.identity
                    })
                }
                
                // reset the text field
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    textField.text = ""
                })
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        switch currentPassphraseKind_
        {
        case .phrase:
            if let passphrase = textField.text,
                !passphrase.isEmpty,
                canAdvanceStep_(enteredPassphrase: passphrase)
            {
                textField.text = ""
                nextStep_(enteredPassphrase: passphrase)
            }
        case .sixDigitCode:
            break
        }
        
        return true
    }
}
