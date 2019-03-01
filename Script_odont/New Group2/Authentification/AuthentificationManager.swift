//
//  AuthentificationManager.swift
//  Script_odont
//
//  Created by Régis Iozzino on 01/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

class AuthentificationManager
{
    static let shared = AuthentificationManager()
    
    private let concurrentAuthentificationQueue_ = DispatchQueue(label: "com.example.regis.script_odont", attributes: .concurrent)
    
    fileprivate var authentified_ = false
    
    var authentified: Bool {
        set {
            concurrentAuthentificationQueue_.async(flags: .barrier) {
                self.authentified_ = newValue
            }
        }
        get {
            var result = false
            
            concurrentAuthentificationQueue_.sync {
                result = self.authentified_
            }
            
            return result
        }
    }
    
    private init()
    {
    }
}
