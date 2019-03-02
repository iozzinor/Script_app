//
//  ViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 01/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class ViewController: UITabBarController
{
    static let mainToLogin = "MainToLoginSegueId"
    
    private var firstDisplay_ = true
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if firstDisplay_
        {
            firstDisplay_ = false
            performSegue(withIdentifier: ViewController.mainToLogin, sender: nil)
        }
    }
}
