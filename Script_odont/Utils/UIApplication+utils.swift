//
//  UIApplication+isFirstLaunch.swift
//  Script_odont
//
//  Created by Régis Iozzino on 21/02/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

extension UIApplication
{
    // -------------------------------------------------------------------------
    // MARK: - FIRST LAUNCH
    // -------------------------------------------------------------------------
    public static let firstLaunchKey = "applicationHasBeenLaunchedBefore"
    
    static var isFirstLaunch: Bool {
    #if DEBUG
        return false
    #else
        
        if !UserDefaults.standard.bool(forKey: firstLaunchKey)
        {
            UserDefaults.standard.set(true, forKey: firstLaunchKey)
            return true
        }
        
        return false
    #endif
    }
    
    // -------------------------------------------------------------------------
    // MARK: - VERSION
    // -------------------------------------------------------------------------
    static var applicationVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    static var applicationBuild: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
    // -------------------------------------------------------------------------
    // MARK: - OPEN PREFERENCES
    // -------------------------------------------------------------------------
    func openPreferences()
    {
        open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    }
}
