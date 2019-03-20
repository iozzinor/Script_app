//
//  AuthentificationManager.swift
//  Script_odont
//
//  Created by Régis Iozzino on 01/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation
import LocalAuthentication

class AuthenticationManager
{
    // -------------------------------------------------------------------------
    // MARK: - KEYCHAIN
    // -------------------------------------------------------------------------
    fileprivate enum KeychainConfiguration
    {
        static let service = "com.example.regis.script_odont.password"
        static let accessGroup: String? = nil
    }
    
    // -------------------------------------------------------------------------
    // MARK: - BIOMETRIC AUTHENTICATION
    // -------------------------------------------------------------------------
    struct BiometricAuthentication
    {
        let context = LAContext()
        
        func canEvaluatePolicy() -> Bool
        {
            return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        }
        
        var biometricType: LABiometryType
        {
            guard canEvaluatePolicy() else
            {
                return .none
            }
            return context.biometryType
        }
        
        var authenticationName: String
        {
            let authenticationBiometricType = biometricType
            switch authenticationBiometricType
            {
            case .none:
                return ""
            case .faceID:
                return "Authentication.Biometry.FaceId.Name".localized
            case .touchID:
                return "Authentication.Biometry.TouchId.Name".localized
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - STATIC PROPERTIES
    // -------------------------------------------------------------------------
    static let shared = AuthenticationManager()
    
    fileprivate static let userNameKey_ = "username"
    fileprivate static let saltKey_ = "salt"
    fileprivate static let saltLength_ = 128
    
    // -------------------------------------------------------------------------
    // MARK: - STATIC FUNCTIONS
    // -------------------------------------------------------------------------
    fileprivate static func generateSalt_(length: Int = saltLength_) -> String
    {
        return String.random(length: length)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - STORED PROPERTIES
    // -------------------------------------------------------------------------
    private let concurrentAuthenticationQueue_ = DispatchQueue(label: "com.example.regis.script_odont.authentication", attributes: .concurrent)
    
    fileprivate var authenticated_ = false
    let biometricAuthentication = BiometricAuthentication()
    fileprivate var userName_: String? = nil
    fileprivate var salt_: String? = nil
    
    // -------------------------------------------------------------------------
    // MARK: - INIT
    // -------------------------------------------------------------------------
    private init()
    {
        userName_ = UserDefaults.standard.string(forKey: AuthenticationManager.userNameKey_)
        salt_ = UserDefaults.standard.string(forKey: AuthenticationManager.saltKey_)
    }
    
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
    
    var userName: String? {
        get {
            var result: String? = nil
            concurrentAuthenticationQueue_.sync {
                result = self.userName_
            }
            return result
        }
        set {
            concurrentAuthenticationQueue_.async(flags: .barrier) {
                self.userName_ = newValue
            }
        }
    }
    
    var salt: String? {
        get {
            var result: String? = nil
            concurrentAuthenticationQueue_.sync {
                result = self.salt_
            }
            return result
        }
        set
        {
            concurrentAuthenticationQueue_.async(flags: .barrier) {
                self.salt_ = newValue
            }
        }
    }
    
    func authenticateUserUsingBiometry(completion: @escaping (Error?) -> Void)
    {
        let authenticationReason = String.localizedStringWithFormat("Authentication.Reason".localized, biometricAuthentication.authenticationName)
        
        biometricAuthentication.context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: authenticationReason, reply: {
            (success, error) -> Void in
            
            if success
            {
                self.authenticated = true
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
            else if let error = error
            {
                self.authenticated = false
                completion(error)
            }
        })
    }
    
    func storeAccountInformation()
    {
        // store the user name and the salt
        UserDefaults.standard.set(userName_, forKey: AuthenticationManager.userNameKey_)
        UserDefaults.standard.set(salt_, forKey: AuthenticationManager.saltKey_)
    }
}
