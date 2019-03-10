//
//  Constants.swift
//  Script_odont
//
//  Created by Régis Iozzino on 08/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import UIKit

/// Utils fonctions and constants.
struct Constants
{
    /// - returns: The current device orientation.
    static var deviceOrientation: UIDeviceOrientation {
        return UIDevice.current.orientation
    }
    
    /// - returns: Whether the current device orientation is horizontal.
    static var isDeviceOrientationHorizontal: Bool {
        switch UIDevice.current.orientation
        {
        case .portrait, .portraitUpsideDown:
            return false
        case .faceDown, .faceUp, .landscapeLeft, .landscapeRight, .unknown:
            return true
        }
    }
    
    /// - returns: The local short representation of a date.
    static func dateString(for date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter.string(for: date) ?? ""
    }
}
