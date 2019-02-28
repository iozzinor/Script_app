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
}
