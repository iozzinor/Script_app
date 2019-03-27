//
//  UnlockViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit
import LocalAuthentication

class UnlockViewController: UIViewController
{
    @IBOutlet weak var passphraseView: UIView!
    @IBOutlet weak var biometricAuthenticationButton: UIButton!
    
    fileprivate var passphraseKind_ = Passphrase.Kind.sixDigitCode
    fileprivate var passphraseControl_: UIControl?
    {
        didSet
        {
            passphraseControl_?.translatesAutoresizingMaskIntoConstraints = false
            passphraseControl_?.becomeFirstResponder()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setup_()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SETUP
    // -------------------------------------------------------------------------
    fileprivate func setup_()
    {
        setupPassphraseView_()
        setupBiometricAuthentication_()
    }
    
    fileprivate func setupPassphraseView_()
    {
        if let passphraseKind = AuthenticationManager.shared.passphraseKind
        {
            passphraseKind_ = passphraseKind
        }
        
        switch passphraseKind_
        {
        case .sixDigitCode:
            setupSixDigitCodePassphrase_()
            
        case .phrase:
            setupPhrase_()
        }
    }
    
    fileprivate func setupSixDigitCodePassphrase_()
    {
        let numericPassphraseControl = NumericPassphraseControl()
        numericPassphraseControl.delegate = self
        passphraseControl_ = numericPassphraseControl
        passphraseView.addSubview(numericPassphraseControl)
        passphraseView.adjustSubview(numericPassphraseControl)
    }
    
    fileprivate func setupPhrase_()
    {
        let passphraseField = UITextField()
        passphraseControl_ = passphraseField
        passphraseField.textContentType = .password
        passphraseField.isSecureTextEntry = true
        passphraseField.delegate = self
        passphraseView.addSubview(passphraseField)
        passphraseView.adjustSubview(passphraseField)
    }
    
    fileprivate func setupBiometricAuthentication_()
    {
        biometricAuthenticationButton.isHidden = !AuthenticationManager.shared.biometricAuthentication.canEvaluatePolicy()
        if !biometricAuthenticationButton.isHidden
        {
            biometricAuthenticationButton.setTitle(AuthenticationManager.shared.biometricAuthentication.authenticationName, for: .normal)
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @IBAction func forgotPassword(_ sender: UIButton)
    {
        informDeleteAll_()
    }
    
    @IBAction func biometricLoginAction(_ sender: UIButton)
    {
        AuthenticationManager.shared.authenticateUserUsingBiometry {
            (error: Error?) -> Void in
            
            if let error = error
            {
                self.displayErrorMessage_(error)
            }
            else
            {
                self.confirmAuthentication_()
            }
        }
    }
    
    fileprivate func confirmAuthentication_()
    {
        AuthenticationManager.shared.authenticated = true
        self.dismiss(animated: true, completion: nil)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - ERROR MESSAGE
    // -------------------------------------------------------------------------
    fileprivate func displayErrorMessage_(_ error: Error)
    {
        guard let errorMessage = getErrorMessage_(for: error) else
        {
            return
        }
        
        let errorAlert = UIAlertController(title: "Login.Error.AlertTitle".localized, message: errorMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Common.Ok".localized, style: .default, handler: nil)
        
        errorAlert.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(errorAlert, animated: true)
        }
    }
    
    fileprivate func getErrorMessage_(for error: Error) -> String?
    {
        switch error
        {
        case LAError.authenticationFailed:
            return "Login.Error.AuthenticationFailed".localized
        case LAError.userCancel, LAError.userFallback:
            return nil
        case LAError.biometryNotEnrolled:
            return "Login.Error.BiometryNotEnrolled".localized
        case LAError.biometryNotAvailable:
            return "Login.Error.BiometryNotAvailable".localized
        case LAError.biometryLockout:
            return "Login.Error.BiometryLocked".localized
        default:
            return "Login.Error.BiometryNotConfigured".localized
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - DELETE ALL
    // -------------------------------------------------------------------------
    fileprivate func informDeleteAll_()
    {
        let informController = UIAlertController(title: "Unlock.DeleteAll.Inform.Title".localized, message: "Unlock.DeleteAll.Inform.Message".localized, preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "Common.No".localized, style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "Common.Yes".localized, style: .destructive, handler: {
            _ -> Void in
            
            self.confirmDeleteAll_()
        })
        yesAction.isEnabled = false
        informController.addAction(noAction)
        informController.addAction(yesAction)
        
        present(informController, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                yesAction.isEnabled = true
            })
        })
    }
    
    fileprivate func confirmDeleteAll_()
    {
        let informController = UIAlertController(title: "Unlock.DeleteAll.Confirm.Title".localized, message: "Unlock.DeleteAll.Confirm.Message".localized, preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "Common.No".localized, style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "Common.Yes".localized, style: .destructive, handler: {
            _ -> Void in
            
            self.doubleConfirmDeleteAll_()
        })
        yesAction.isEnabled = false
        informController.addAction(noAction)
        informController.addAction(yesAction)
        
        present(informController, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                yesAction.isEnabled = true
            })
        })
    }
    
    fileprivate func doubleConfirmDeleteAll_()
    {
        let informController = UIAlertController(title: "Unlock.DeleteAll.DoubleConfirm.Title".localized, message: "Unlock.DeleteAll.DoubleConfirm.Message".localized, preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "Common.No".localized, style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "Common.Yes".localized, style: .destructive, handler: {
            _ -> Void in
            
            self.deleteAll_()
        })
        yesAction.isEnabled = false
        informController.addAction(noAction)
        informController.addAction(yesAction)
        
        present(informController, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                yesAction.isEnabled = true
            })
        })
    }
    
    fileprivate func deleteAll_()
    {
        view.isUserInteractionEnabled = false
        
        _ = Settings.shared.clear()
        
        let successController = UIAlertController(title: "Unlock.DeleteAll.Success.Title".localized, message: "Unlock.DeleteAll.Success.Message".localized, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Common.Ok".localized, style: .default, handler: {
            _ -> Void in
            self.displayPassphraseSelection_()
        })
        successController.addAction(okAction)
        
        present(successController, animated: true, completion: nil)
    }
    
    fileprivate func displayPassphraseSelection_()
    {
        let passphraseStoryboard = UIStoryboard(name: "Passphrase", bundle: nil)
        if let passphraseViewController = passphraseStoryboard.instantiateInitialViewController() as? PassphraseViewController
        {
            passphraseViewController.delegate = self
            present(passphraseViewController, animated: true, completion: nil)
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - UI TEXT FIELD DELEGATE
// -----------------------------------------------------------------------------
extension UnlockViewController: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let newString = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string) as String
        
        switch passphraseKind_
        {
        case .phrase:
            break
        case .sixDigitCode:
            
            if newString.count == 6
            {
                if AuthenticationManager.shared.checkPassphrase(newString)
                {
                    confirmAuthentication_()
                }
                else
                {
                    // show the error
                    textField.animateErrorShake()
                    textField.text = ""
                    return false
                }
            }
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        switch passphraseKind_
        {
        case .phrase:
            if let passphrase = textField.text,
               AuthenticationManager.shared.checkPassphrase(passphrase)
            {
                confirmAuthentication_()
            }
            else
            {
                textField.selectAll(self)
                textField.animateErrorShake()
            }
        case .sixDigitCode:
            break
        }
        
        return true
    }
}

// -----------------------------------------------------------------------------
// MARK: - PASSPHRASE DELEGATE
// -----------------------------------------------------------------------------
extension UnlockViewController: PassphraseDelegate
{
    func passphraseViewController(_ passphraseViewController: PassphraseViewController, didChoosePassphrase passphrase: Passphrase)
    {
        passphraseViewController.dismiss(animated: true, completion: nil)
        
        AuthenticationManager.shared.storePassphrase(passphrase.text, kind: passphrase.kind)
        
        dismiss(animated: true, completion: nil)
    }
}
