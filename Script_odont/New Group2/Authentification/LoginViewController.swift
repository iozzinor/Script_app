//
//  LoginViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 01/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController
{
    static let toSigninSegueId = "LoginToSigninSegueId"
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var biometricButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let userName = AuthenticationManager.shared.userName
        {
            userNameField.text = userName
        }
        
        biometricButton.isHidden = !AuthenticationManager.shared.biometricAuthentication.canEvaluatePolicy()
        biometricButton.setTitle(AuthenticationManager.shared.biometricAuthentication.authenticationName, for: .normal)
    }
    
    fileprivate func isPasswordValid(_ password: String) -> Bool
    {
        return PasswordPolicy.shared.isValid(password: password)
    }
    
    @IBAction func login(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
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
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
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
    
    func getErrorMessage_(for error: Error) -> String?
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
    // MARK: - ACTIONS
    // -------------------------------------------------------------------------
    @IBAction func signin(_ sender: UIButton)
    {
        performSegue(withIdentifier: LoginViewController.toSigninSegueId, sender: self)
    }
}
