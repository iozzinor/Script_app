//
//  LoginViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 01/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{
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
}
