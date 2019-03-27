//
//  Configuration.swift
//  Script_odont
//
//  Created by Régis Iozzino on 27/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

public class Configuration
{
    public static let shared = Configuration()
    
    var configurationParameters_: NSDictionary? = nil
    
    private init()
    {
        if let configurationPath = Bundle.main.path(forResource: "Configuration", ofType: "plist")
        {
            configurationParameters_ = NSDictionary(contentsOfFile: configurationPath)
        }
    }
    
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
}
