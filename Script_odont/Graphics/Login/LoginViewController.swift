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
    static let toRecoverPassworrd = "LoginToRecoverPasswordSegueId"
    static let toSignin = "LoginToSigninSegueId"
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let userName = Settings.shared.accountUsername
        {
            userNameField.text = userName
        }
        passwordField.isSecureTextEntry = true
    }
    
    fileprivate func isPasswordValid(_ password: String) -> Bool
    {
        return PasswordPolicy.shared.isValid(password: password)
    }
    
    @IBAction func recoverPassword(_ sender: UIButton)
    {
        performSegue(withIdentifier: LoginViewController.toRecoverPassworrd, sender: self)
    }
    
    @IBAction func login(_ sender: UIButton)
    {
        let userName = userNameField.text ?? ""
        let password = passwordField.text ?? ""
        NetworkingService.shared.authenticateUser(userName: userName, password: password, authenticationCompletion: {
            (authenticated) -> Void in
            
            DispatchQueue.main.async {
                self.loginCallback_(authenticated: authenticated, userName: userName, password: password)
            }
        })
    }
    
    fileprivate func loginCallback_(authenticated: Bool, userName: String, password: String)
    {
        if !authenticated
        {
            self.passwordField.becomeFirstResponder()
            self.passwordField.selectAll(nil)
            self.passwordField.animateErrorShake()
        }
        else
        {
            storeCredentialsKey_(userName: userName, password: password, completion: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    fileprivate func storeCredentialsKey_(userName: String, password: String, completion: @escaping () -> Void)
    {
        NetworkingService.shared.getCredentialsKey(forUser: userName, password: password, completion: {
            (credentialsKey) -> Void in
            
            Settings.shared.accountUsername = userName
            Settings.shared.accountKey = credentialsKey
            
            completion()
        })
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
        performSegue(withIdentifier: LoginViewController.toSignin, sender: self)
    }
}
