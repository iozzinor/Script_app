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
    
    /// - returns: The textual representation of the duration expressed in seconds.
    static func durationString(forTimeInterval timeInterval: TimeInterval) -> String
    {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        
        return String(format: "Constants.Duration.String.Format.Short".localized, minutes, seconds)
    }
    
    /// If the max value is lower than the min one, then they are switched.
    /// - returns: A random number in the range [min; max].
    static func random(min: Int, max: Int) -> Int
    {
        if min == max
        {
            return min
        }
        else if min > max
        {
            return random(min: max, max: min)
        }
        
        return Int(arc4random()) % (max - min + 1) + min
    }
    
    /// If min and max are equal, then min is returned, regarless of the input value.
    /// If min is greater than max, then they are switched.
    /// - returns: The bounded value.
    static func bound<T: Comparable>(_ value: T, min: T, max: T) -> T
    {
        if min == max
        {
            return min
        }
        else if min > max
        {
            return bound(value, min: max, max: min)
        }
        else if value < min
        {
            return min
        }
        else if value > max
        {
            return max
        }
        return value
    }
    
    static func inRange<T: Comparable>(_ value: T, min: T, max: T) -> Bool
    {
        if min > max
        {
            return inRange(value, min: max, max: min)
        }
        return !(value < min || value > max)
    }
}
