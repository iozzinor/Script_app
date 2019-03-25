//
//  Settings.swift
//  Script_odont
//
//  Created by Régis Iozzino on 25/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

class Settings
{
    enum Parameter: String
    {
        case showDeveloperSection
        case serverName
        case serverPort
        
        var key: String {
            return "Settings.\(rawValue)"
        }
    }
    
    static let shared = Settings()
    
    var showDeveloper: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: Parameter.showDeveloperSection.key)
        }
        get {
            return UserDefaults.standard.bool(forKey: Parameter.showDeveloperSection.key)
        }
    }
    var serverName: String {
        set {
            UserDefaults.standard.set(newValue, forKey: Parameter.serverName.key)
        }
        get {
            return UserDefaults.standard.value(forKey: Parameter.serverName.key) as? String ?? ""
        }
    }
    var serverPort: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: Parameter.serverPort.key)
        }
        get {
            return UserDefaults.standard.integer(forKey: Parameter.serverPort.key)
        }
    }
    
    private init()
    {
    }
    
    var defaultValues: [String: Any] {
        return [
            Parameter.showDeveloperSection.key: false,
            Parameter.serverName.key: "localhost",
            Parameter.serverPort.key: 80
        ]
    }
}
