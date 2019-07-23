//
//  Configuration.swift
//  Script_odont
//
//  Created by Régis Iozzino on 27/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

/// Access configuration information.
public class Configuration
{
    /// Singleton attribute.
    public static let shared = Configuration()
    
    /// The configuration parameters.
    var configurationParameters_: NSDictionary? = nil
    
    /// Private initializer to implement the singleton pattern.
    private init()
    {
        if let configurationPath = Bundle.main.path(forResource: "Configuration", ofType: "plist")
        {
            configurationParameters_ = NSDictionary(contentsOfFile: configurationPath)
        }
    }
    
    /// Get a configuration parameter.
    ///
    /// - parameter argument: The configuration key.
    ///
    /// - returns: The configuration value or `nil` if the key is not found.
    public func readFromFile(argument: String) -> String?
    {
        if let result = configurationParameters_?[argument] as? String
        {
            return result
        }
        else if let object = configurationParameters_?[argument]
        {
            return String(describing: object)
        }
        return nil
    }
    
    /// - returns: The configuration boolean value if found.
    public func readBoolean(argument: String) -> Bool?
    {
        guard let argumentString = readFromFile(argument: argument) else
        {
            return nil
        }
        return argumentString == "1"
    }
}
