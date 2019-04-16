//
//  NetworkingService.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

class NetworkingService
{
    typealias JsonCompletion = ((Json?) -> Void)?
    
    static let shared = NetworkingService()
    
    /// The minimum time in seconds between two connection status fetches.
    fileprivate static let minimumUpdateInterval_ = 10
    
    fileprivate var lastUpdateTime_ = time(nil)
    fileprivate let ephemeralSession_: URLSession
    fileprivate let concurrentQueue_ = DispatchQueue(label: "com.example.regis.script_odont.networking_service", qos: .background, attributes: .concurrent)
    fileprivate var connectionStatus_ = ConnectionStatus.unknown
    
    var connectionStatus: ConnectionStatus {
        get {
            var result: ConnectionStatus!
            
            concurrentQueue_.sync {
                result = self.connectionStatus_
            }
            
            return result
        }
    }
    
    private init()
    {
        self.ephemeralSession_ = URLSession(configuration: .ephemeral)
    }
    
    fileprivate func updateConnectionStatus_(_ newStatus: ConnectionStatus)
    {
        concurrentQueue_.async(flags: .barrier) {
            [weak self] in
            
            guard let self = self else
            {
                return
            }
            
            self.connectionStatus_ = newStatus
        }
    }
    
    fileprivate func updateConnectionInformation_(completion: (() -> Void?)?)
    {
        // check that the device can get connected to the Internet
        switch Reachability.currentStatus
        {
        case .notReachable:
            updateConnectionStatus_(.error(NetworkError.notReachable))
            completion?()
            return
        case .reachableViaWifi, .reachableViaWwan:
            break
        }
        
        // check last update time
        switch connectionStatus
        {
        case .information(_):
            if time(nil) - lastUpdateTime_ < NetworkingService.minimumUpdateInterval_
            {
                completion?()
                return
            }
        case .error(_), .unknown:
            break
        }
        lastUpdateTime_ = time(nil)
        
        // check that the user has linked an account
        guard let accountKey = Settings.shared.accountKey else
        {
            updateConnectionStatus_(.error(ConnectionError.noAccountLinked))
            completion?()
            return
        }
        
        // check that the credential is valid
        // check that the account has been activated
        authenticateUser_(credentialsKey: accountKey, completionHandler: {
            (json) -> Void in
            
            guard let json = json,
                let information = json["information"] as? Json,
                let credentialsValid = information["credentials_valid"] as? Bool
                else
            {
                completion?()
                return
            }
            
            let accountActivated = information["account_activated"] as? Bool ?? false
            if !credentialsValid
            {
                // remove invalid credentials
                self.revokeCredentials_(key: accountKey)
                self.updateConnectionStatus_(.error(ConnectionError.wrongCredentials))
            }
            else if !accountActivated
            {
                self.updateConnectionStatus_(.error(ConnectionError.accountNoActivated))
            }
            else
            {
                self.updateConnectionStatus_(.information(ConnectionInformation(host: Settings.shared.host, accountKey: accountKey)))
            }
            
            completion?()
        })
    }
    
    func updateConnectionInformation(completion: (() -> Void)?)
    {
        concurrentQueue_.async {
            self.updateConnectionInformation_(completion: completion)
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - LOGOUT
    // -------------------------------------------------------------------------
    func logout()
    {
        Settings.shared.accountUsername = nil
        Settings.shared.accountKey = nil
        
        updateConnectionStatus_(.error(ConnectionError.noAccountLinked))
    }
    
    // -------------------------------------------------------------------------
    // MARK: - AUTHENTICATION
    // -------------------------------------------------------------------------
    func authenticateUser(userName: String, password: String, authenticationCompletion: @escaping (Bool) -> Void)
    {
        let parameters: Json = [
            "username": userName,
            "password": password
        ]
        executeHttpRequest_(uri: "user/check_credentials", postParameters: parameters, completionHandler: {
            (json) -> Void in
            
            guard let json = json else
            {
                authenticationCompletion(false)
                return
            }
            
            if json.keys.contains("exception")
            {
                authenticationCompletion(false)
            }
            else
            {   
                authenticationCompletion(true)
            }
        })
    }
    
    fileprivate func authenticateUser_(credentialsKey: String, completionHandler: JsonCompletion)
    {
        let parameters: Json = [
            "credentials_key": credentialsKey
        ]
        executeHttpRequest_(uri: "user/check_credentials", postParameters: parameters, completionHandler: completionHandler)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - CREATE ACCOUNT
    // -------------------------------------------------------------------------
    
    func createAccount(userName: String, password: String, mailAddress: String)
    {
        let parameters: Json = [
            "username": userName,
            "password": password,
            "mail_address": mailAddress
        ]
        
        executeHttpRequest_(uri: "user/create", postParameters: parameters, completionHandler: nil)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - CREDENTIALS
    // -------------------------------------------------------------------------
    func getCredentialsKey(forUser userName: String, password: String, completion: @escaping (String?) -> Void)
    {
        let parameters: Json = [
            "username": userName,
            "password": password
        ]
        executeHttpRequest_(uri: "user/check_credentials", postParameters: parameters, completionHandler: {
            (json) -> Void in
            
            guard let json = json,
                // get information
                json.keys.contains("information"),
                let information = json["information"] as? Json,
                // get credential list
                information.keys.contains("credentials_list"),
                let credentialsList = information["credentials_list"] as? Array<Any>
                    else
            {
                completion(nil)
                return
            }
            
            // create a new credentials key
            if credentialsList.isEmpty
            {
                self.createCredentialsKey_(forUser: userName, password: password, completion: completion)
            }
            // retrieve the last credentials key
            else
            {
                let credentialsKeyDictionary = credentialsList.last! as? Json
                completion(credentialsKeyDictionary?["key"] as? String)
            }
        })
    }
    
    fileprivate func createCredentialsKey_(forUser userName: String, password: String, completion: @escaping (String?) -> Void)
    {
        let parameters: [String: Any] = [
            "username": userName,
            "password": password
        ]
        executeHttpRequest_(uri: "user/create_credentials", postParameters: parameters, completionHandler: {
            (json) -> Void in
            
            guard let json = json,
                // get information
                let information = json["information"] as? Json,
                // get new key
                let newCredentials = information["new_credentials"] as? Json,
                let credentialsKey = newCredentials["key"] as? String
                    else
            {
                completion(nil)
                return
            }
            completion(credentialsKey)
        })
    }
    
    fileprivate func revokeCredentials_(key: String)
    {
        let parameters: [String: Any] = [
            "credentials_key": key
        ]
        executeHttpRequest_(uri: "user/revoke_credentials", postParameters: parameters, completionHandler: nil)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UTILS
    // -------------------------------------------------------------------------
    fileprivate func executeHttpRequest_(uri: String, postParameters: [String: Any], completionHandler: JsonCompletion)
    {
        guard let url = URL(string: Settings.shared.host.name + "/api/1/\(uri)") else
        {
            return
        }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        request.httpBody = postParameters.percentEscaped().data(using: .utf8)
        
        let task = ephemeralSession_.dataTask(with: request) {
            data, response, error -> Void in
            
            guard let data = data,
                let responseString = String(data: data, encoding: .utf8) else
            {
                return
            }
            
            let json = dictionaryFrom(jsonString: responseString)
            completionHandler?(json)
        }
        task.resume()
    }
}
