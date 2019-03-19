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
    fileprivate static let numberFormatter_: NumberFormatter = ({
        let result = NumberFormatter()
        result.locale = Locale.current
        result.minimumFractionDigits = 1
        result.maximumFractionDigits = 1
        result.maximumIntegerDigits = 9
        result.minimumIntegerDigits = 1
        return result
    })()
    
    // -------------------------------------------------------------------------
    // MARK: - ORIENTATION
    // -------------------------------------------------------------------------
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
    
    // -------------------------------------------------------------------------
    // MARK: - DATE
    // -------------------------------------------------------------------------
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
    
    /// An array of localized month names.
    static let monthNames: [String] =
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        
        var result = [String]()
        
        var components = DateComponents(calendar: Calendar.current, timeZone: nil, era: nil, year: nil, month: nil, day: nil, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        for month in 1..<13
        {
            components.month = month
            
            if let date = Calendar.current.date(from: components)
            {
                result.append(dateFormatter.string(from: date))
            }
        }
        
        return result
    }()
    
    // -------------------------------------------------------------------------
    // MARK: - RANDOM
    // -------------------------------------------------------------------------
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
    
    // -------------------------------------------------------------------------
    // MARK: - BOUND
    // -------------------------------------------------------------------------
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
    
    // -------------------------------------------------------------------------
    // MARK: - NUMBER FORMATTING
    // -------------------------------------------------------------------------
    static func formatReal(_ value: Double) -> String
    {
        return numberFormatter_.string(from: NSNumber(value: value)) ?? ""
    }
}
