//
//  AuthentificationManager.swift
//  Script_odont
//
//  Created by Régis Iozzino on 01/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

class AuthenticationManager
{
    static let shared = AuthenticationManager()
    
    private let concurrentAuthenticationQueue_ = DispatchQueue(label: "com.example.regis.script_odont.authentication", attributes: .concurrent)
    
    fileprivate var authenticated_ = false
    
    var authenticated: Bool {
        set {
            concurrentAuthenticationQueue_.async(flags: .barrier) {
                self.authenticated_ = newValue
            }
        }
        get {
            var result = false
            
            concurrentAuthenticationQueue_.sync {
                result = self.authenticated_
            }
            
            return result
        }
    }
    
    private init()
    {
    }
}
