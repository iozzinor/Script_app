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
        static let service = "com.example.regis.script_odont.passphrase"
        static let account = ""
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
    
    fileprivate static let passphraseKindKey_ = "passphrase.kind"
    fileprivate static let hashIterations_ = 100
    
    // -------------------------------------------------------------------------
    // MARK: - STORED PROPERTIES
    // -------------------------------------------------------------------------
    private let concurrentAuthenticationQueue_ = DispatchQueue(label: "com.example.regis.script_odont.authentication", attributes: .concurrent)
    
    fileprivate var authenticated_ = false
    let biometricAuthentication = BiometricAuthentication()
    fileprivate var passphraseKeychain_ = KeychainPasswordItem(service: KeychainConfiguration.service, account: KeychainConfiguration.account, accessGroup: KeychainConfiguration.accessGroup)
    
    // -------------------------------------------------------------------------
    // MARK: - INIT
    // -------------------------------------------------------------------------
    private init()
    {
    }
    
    var authenticated: Bool {
        set {
            concurrentAuthenticationQueue_.async(flags: .barrier) {
                self.authenticated_ = newValue
            }
        }
        get {
            #if DEBUG
                return Configuration.shared.readBoolean(argument: "IsAuthenticated") ?? false
            #else
                var result = false
            
                concurrentAuthenticationQueue_.sync {
                    result = self.authenticated_
                }
            
                return result
            #endif
        }
    }
    
    var passphraseKind: Passphrase.Kind? {
        get {
            var result: Passphrase.Kind?
            
            concurrentAuthenticationQueue_.sync {
                
                if let passphraseKindRawValue = UserDefaults.standard.string(forKey: AuthenticationManager.passphraseKindKey_)
                {
                    result = Passphrase.Kind(rawValue: passphraseKindRawValue)
                }
            }
            
            return result
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
    
    func storePassphrase(_ phrase: String, kind: Passphrase.Kind)
    {
        concurrentAuthenticationQueue_.async(flags: .barrier) {
            
            UserDefaults.standard.set(kind.rawValue, forKey: AuthenticationManager.passphraseKindKey_)
            
            let hashedPhrase = self.hashPassword_(phrase)
            
            do
            {
                try self.passphraseKeychain_.savePassword(hashedPhrase)
            }
            catch
            {
            }
        }
    }
    
    func storePassphrase(_ passphrase: Passphrase)
    {
        storePassphrase(passphrase.text, kind: passphrase.kind)
    }
    
    func checkPassphrase(_ phrase: String) -> Bool
    {
        do
        {
            return try passphraseKeychain_.readPassword() == hashPassword_(phrase)
        }
        catch
        {
            return false
        }
    }
    
    /// - returns: The password hash that will be stored in the keychain.
    fileprivate func hashPassword_(_ password: String) -> String
    {
        var result = password
        for _ in 0..<AuthenticationManager.hashIterations_
        {
            result = result.sha512
        }
        return result
    }
}
