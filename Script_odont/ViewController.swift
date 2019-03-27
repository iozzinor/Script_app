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
    static let toUnlock = "MainToUnlockSegueId"
    
    private var isFirstDisplay_ = true
    private var shouldDisplayPassphraseCreation_ = false
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if isFirstDisplay_
        {
            isFirstDisplay_ = false
            
            if UIApplication.isFirstLaunch
            {
                shouldDisplayPassphraseCreation_ = true
                displayWelcomeWalkthrough_()
            }
            else
            {
                displayUnlock_()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if shouldDisplayPassphraseCreation_
        {
            shouldDisplayPassphraseCreation_ = false
            
            displayPassphraseCreation_()
        }
    }
    
    func showSettings()
    {
        guard let controllers = viewControllers else
        {
            return
        }
        for (i, viewController) in controllers.enumerated()
        {
            if let navigationController = viewController as? UINavigationController,
                let firstViewController = navigationController.viewControllers.first
            {
                if firstViewController is SettingsViewController
                {
                    selectedIndex = i
                }
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUES
    // -------------------------------------------------------------------------
    fileprivate func displayWelcomeWalkthrough_()
    {
        let welcomeStoryboard = UIStoryboard(name: "WelcomeWalkthrough", bundle: nil)
        if let viewController = welcomeStoryboard.instantiateInitialViewController()
        {
            present(viewController, animated: true, completion: nil)
        }
    }
    
    fileprivate func displayPassphraseCreation_()
    {
        let passphraseStoryboard = UIStoryboard(name: "Passphrase", bundle: nil)
        if let passphraseViewController = passphraseStoryboard.instantiateInitialViewController() as? PassphraseViewController
        {
            passphraseViewController.delegate = self
            present(passphraseViewController, animated: true, completion: nil)
        }
    }
    
    fileprivate func displayUnlock_()
    {
        performSegue(withIdentifier: ViewController.toUnlock, sender: nil)
    }
}

// -----------------------------------------------------------------------------
// MARK: - PASSPHRASE DELEGATE
// -----------------------------------------------------------------------------
extension ViewController: PassphraseDelegate
{
    func passphraseViewController(_ passphraseViewController: PassphraseViewController, didChoosePassphrase passphrase: Passphrase)
    {
        passphraseViewController.dismiss(animated: true, completion: nil)
        
        AuthenticationManager.shared.storePassphrase(passphrase.text, kind: passphrase.kind) 
    }
}
