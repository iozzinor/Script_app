//
//  ViewController.swift
//  Script_odont
//
//  Created by Régis Iozzino on 01/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController
{
    // -------------------------------------------------------------------------
    // MARK: - MENU ITEM
    // -------------------------------------------------------------------------
    enum MenuItem: CaseIterable
    {
        case toothRecognition
        case therapeuticBasic
        case therapeuticScale
        case sctBrowsing
        case mySct
        case settings
        case other
        
        var segueId: String {
            switch self
            {
            case .toothRecognition:
                return "MainToToothRecognitionSegueId"
            case .therapeuticBasic:
                return "MainToTherapeuticBasicSegueId"
            case .therapeuticScale:
                return "MainToTherapeuticScaleSegueId"
            case .sctBrowsing:
                return "MainToSctBrowsingSegueId"
            case .mySct:
                return "MainToMySctSegueId"
            case .settings:
                return "MainToSettingsSegueId"
            case .other:
                return "MainToOtherSegueId"
            }
        }
        
        var name: String {
            switch self
            {
            case .toothRecognition:
                return "Main.Menu.Item.ToothRecognition".localized
            case .therapeuticBasic:
                return "Main.Menu.Item.TherapeuticBasic".localized
            case .therapeuticScale:
                return "Main.Menu.Item.TherapeuticScale".localized
            case .sctBrowsing:
                return "Main.Menu.Item.SctBrowsing".localized
            case .mySct:
                return "Main.Menu.Item.MySct".localized
            case .settings:
                return "Main.Menu.Item.Settings".localized
            case .other:
                return "Main.Menu.Item.Other".localized
            }
        }
    }
    
    public static let toUnlock      = "MainToUnlockSegueId"
    
    private static let topInset_: CGFloat   = 10
    private static let padding_: CGFloat    = 0.1
    private static let itemsPerLine_        = 2
    
    private var isFirstDisplay_                     = true
    private var shouldDisplayPassphraseCreation_    = false
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
    
    // -------------------------------------------------------------------------
    // MARK: - VIEW CYCLE
    // -------------------------------------------------------------------------
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        collectionView.registerNibCell(MenuItemCell.self)
        collectionView.register(UINib(nibName: "MenuHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MenuHeader.reuseId)
    }
    
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
            else if !AuthenticationManager.shared.authenticated
            {
                displayUnlock_()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // passphrase
        if shouldDisplayPassphraseCreation_
        {
            shouldDisplayPassphraseCreation_ = false
            
            displayPassphraseCreation_()
        }
        
        // navigation item
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func showSettings()
    {
        performSegue(withIdentifier: MenuItem.settings.segueId, sender: self)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI COLLECTION VIEW DATA SOURCE
    // -------------------------------------------------------------------------
    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return MenuItem.allCases.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(for: indexPath) as MenuItemCell
        
        let menuItem = MenuItem.allCases[indexPath.row]
        
        cell.backgroundColor = UIColor.blue
        cell.label.text = menuItem.name
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MenuHeader.reuseId, for: indexPath) as! MenuHeader

        view.titleLabel.text = "Main.Menu.Title".localized
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        return CGSize(width: view.frame.width, height: view.frame.height / 3.0)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI COLLECTION VIEW DELEGATE
    // -------------------------------------------------------------------------
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let segueId = MenuItem.allCases[indexPath.row].segueId
        performSegue(withIdentifier: segueId, sender: self)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - SEGUES
    // -------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == MenuItem.therapeuticScale.segueId,
            let target = segue.destination as? TherapeuticTestBasicViewController
        {
            target.selectionMode = .scale(TherapeuticTestBasicViewController.diagnosticScale)
            target.xRay = UIImage(named: "fracture_incisive_radio")
            
            target.stlToothUrl = Bundle.main.url(forResource: "14_1", withExtension: "stl", subdirectory: "ToothRecognition")
        }
        else if segue.identifier == MenuItem.therapeuticBasic.segueId,
            let target = segue.destination as? TherapeuticTestBasicViewController
        {
            target.xRay = UIImage(named: "fracture_incisive_photo")
            
            target.stlToothUrl = Bundle.main.url(forResource: "14_2", withExtension: "stl", subdirectory: "ToothRecognition")
        }
    }
    
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

// -----------------------------------------------------------------------------
// MARK: - UI COLLECTION VIEW DELEGATE FLOW LAYOUT
// -----------------------------------------------------------------------------
extension ViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let availableWidth = view.frame.width * (1 - ViewController.padding_)
        let size = availableWidth / CGFloat(ViewController.itemsPerLine_)
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        let paddingSize = view.frame.width * ViewController.padding_
        let paddingWidth = paddingSize / CGFloat(ViewController.itemsPerLine_ + 1)
        
        return UIEdgeInsets(top: ViewController.topInset_, left: paddingWidth, bottom: ViewController.topInset_, right: paddingWidth)
    }
}
