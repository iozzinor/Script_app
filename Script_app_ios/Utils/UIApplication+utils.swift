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
    /// The first launch key used in the configuration file.
    public static let firstLaunchKey = "applicationHasBeenLaunchedBefore"
    
    /// Whether the application is launched for the first time.
    static var isFirstLaunch: Bool {
    #if DEBUG
        return Configuration.shared.readBoolean(argument: "IsFirstLaunch") ?? false
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
    /// The application version.
    static var applicationVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    /// The application build information.
    static var applicationBuild: String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
    // -------------------------------------------------------------------------
    // MARK: - OPEN PREFERENCES
    // -------------------------------------------------------------------------
    /// Open the preferences application.
    func openPreferences()
    {
        open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    }
}
