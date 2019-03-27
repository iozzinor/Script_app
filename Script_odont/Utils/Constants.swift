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
    
    /// An array of localized day names.
    static let dayNames: [String] =
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        
        var result = [String]()
        
        var components = DateComponents(calendar: Calendar.current, timeZone: nil, era: nil, year: nil, month: nil, day: nil, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: 1, yearForWeekOfYear: nil)
        for weekday in 1..<8
        {
            components.weekday = weekday
            
            if let date = Calendar.current.date(from: components)
            {
                result.append(dateFormatter.string(from: date))
            }
        }
        
        return result
    }()
    
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
    
    /// The last day of the current week.
    static var lastWeekday: Date
    {
        let today = Date()
        var components = Calendar.current.dateComponents(Set([Calendar.Component.yearForWeekOfYear, .weekOfYear, .hour, .minute, .second]), from: today)
        components.weekday = 7
        
        return Calendar.current.date(from: components) ?? today
    }
    
    /// - returns: The first day of the current week.
    static var firstWeekday: Date
    {
        return Date(timeIntervalSinceReferenceDate: lastWeekday.timeIntervalSinceReferenceDate - 6 * 24 * 3600.0)
    }
    
    /// - returns: The number of days in the current month.
    static var daysInCurrentMonth: Int
    {
        func getDay(for date: Date) -> Int
        {
            let components = Calendar.current.dateComponents(Set([Calendar.Component.day]), from: date)
            return components.day ?? -1
        }
        
        func getMonth(for date: Date) -> Int
        {
            let components = Calendar.current.dateComponents(Set([Calendar.Component.month]), from: date)
            return components.month ?? -1
        }
        
        let today = Date()
        let currentMonth = getMonth(for: today)
        var date = today
        var month = currentMonth
        var result = getDay(for: today)
        
        while month == currentMonth
        {
            result += 1
            date = Date(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate + 24 * 3600.0)
            month = getMonth(for: date)
        }
        
        return result - 1
    }
    
    /// Whether the current date format has a 12-hour cycle.
    static var isTwelveHourDateFormat: Bool = {
        let formatter = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!
        return formatter.contains("a")
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
    
    /// - returns: Whether ```value``` is in the range [```min```; ```max```].
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
    /// - returns: The textual representation of the real number.
    static func formatReal(_ value: Double) -> String
    {
        return numberFormatter_.string(from: NSNumber(value: value)) ?? ""
    }
}
