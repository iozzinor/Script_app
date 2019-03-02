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
    // -------------------------------------------------------------------------
    // MARK: - KEYCHAIN
    // -------------------------------------------------------------------------
    fileprivate enum KeychainConfiguration
    {
        static let service = "com.example.regis.script_odont.password"
        static let accessGroup: String? = nil
    }
    
    // -------------------------------------------------------------------------
    // MARK: - BIOMETRIC AUTHENTICATION
    // -------------------------------------------------------------------------
    fileprivate struct BiometricAuthentication
    {
        let context = LAContext()
        
        func canEvaluatePolicy() -> Bool
        {
            return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        }
        
        var biometricType: LABiometryType
        {
            guard canEvaluatePolicy() else
            {
                return .none
            }
            return context.biometryType
        }
        
        var authenticationName: String
        {
            let authenticationBiometricType = biometricType
            switch authenticationBiometricType
            {
            case .none:
                return ""
            case .faceID:
                return "Face ID"
            case .touchID:
                return "Touch ID"
            }
        }
        
        func authenticateUser(completion: @escaping (Error?) -> Void)
        {
            let authenticationReason = "Use \(authenticationName) to unlock the account."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: authenticationReason, reply: {
                (success, error) -> Void in
                
                if success
                {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
                else if let error = error
                {
                    completion(error)
                }
            })
        }
    }
    
    @IBOutlet weak var biometricButton: UIButton!
    fileprivate let biometricAuthentication_ = BiometricAuthentication()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        biometricButton.isHidden = !biometricAuthentication_.canEvaluatePolicy()
        biometricButton.setTitle(biometricAuthentication_.authenticationName, for: .normal)
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
        biometricAuthentication_.authenticateUser {
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
}
