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
    static let shared = NetworkingService()
    
    let ephemeralSession: URLSession
    
    typealias JsonCompletion = ((Json?) -> Void)?
    
    private init()
    {
        self.ephemeralSession = URLSession(configuration: .ephemeral)
    }
    
    func retrieveConnectionInformation(completion: ((ConnectionInformation) -> Void)?) throws
    {
        // check that the device can get connected to the Internet
        switch Reachability.currentStatus
        {
        case .notReachable:
            throw NetworkError.notReachable
        case .reachableViaWifi, .reachableViaWwan:
            break
        }
        
        // check that the user has linked an account
        guard let accountKey = Settings.shared.accountKey else
        {
            throw ConnectionError.noAccountLinked
        }
        
        // check that the credential is valid
        // check that the account has been activated
        authenticateUser_(credentialsKey: "thekey", completionHandler: {
            (json) -> Void in
            
            
        })
        
        completion?(ConnectionInformation(host: Settings.shared.host, accountKey: accountKey))
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
        
        let task = ephemeralSession.dataTask(with: request) {
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
