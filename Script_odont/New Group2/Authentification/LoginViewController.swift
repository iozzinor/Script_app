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
        // between 8 and 128 characters
        if password.count < 8 || password.count > 128
        {
            return false
        }
        
        // at least an uppercase character
        let upper = try! NSRegularExpression(pattern: "[A-Z]")
        // at least a lowercase character
        let lower = try! NSRegularExpression(pattern: "[a-z]")
        // at least a digit
        let digit = try! NSRegularExpression(pattern: "[0-9]")
        
        let passwordRange = NSRange(location: 0, length: password.count)
        
        return upper.numberOfMatches(in: password, options: [], range:  passwordRange) > 0
            && lower.numberOfMatches(in: password, options: [], range:  passwordRange) > 0
            && digit.numberOfMatches(in: password, options: [], range:  passwordRange) > 0
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
        
        let errorAlert = UIAlertController(title: "Authentication", message: errorMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
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
            return "The authentication has failed."
        case LAError.userCancel, LAError.userFallback:
            return nil
        case LAError.biometryNotEnrolled:
            return "Biometry is not enrolled."
        case LAError.biometryNotAvailable:
            return "Biometry is not available."
        case LAError.biometryLockout:
            return "Biometry is locked."
        default:
            return "Biometry may not be configured"
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
