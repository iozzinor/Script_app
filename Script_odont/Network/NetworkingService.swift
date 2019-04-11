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
    
    fileprivate var host_ = Settings.shared.host
    let ephemeralSession: URLSession
    
    private init()
    {
        self.ephemeralSession = URLSession(configuration: .ephemeral)
    }
    
    func getConnectionInformation() throws -> ConnectionInformation
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
        
        return ConnectionInformation(host: host_, accountKey: accountKey)
    }
    
    func authenticateUser(userName: String, password: String, authenticationCompletion: (Bool) -> Void)
    {
        guard let url = URL(string: host_.name + "/api/1/user/check_credentials") else
        {
            return
        }
        print(url)
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "username": userName,
            "password": password
        ]
        
        request.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        let task = ephemeralSession.dataTask(with: request) {
            data, response, error -> Void in
            
            guard let data = data,
                let responseString = String(data: data, encoding: .utf8) else
            {
                return
            }
            
            //print(responseString)
            let json = dictionaryFrom(jsonString: responseString)
            print(json)
        }
        task.resume()
    }
    
    func createAccount(userName: String, password: String, mailAddress: String)
    {
        guard let url = URL(string: host_.name + "/api/1/user/create") else
        {
            return
        }
        print(url)
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let parameters: [String: Any] = [
            "username": userName,
            "password": password,
            "mail_address": mailAddress
        ]
        
        request.httpBody = parameters.percentEscaped().data(using: .utf8)
        
        let task = ephemeralSession.dataTask(with: request) {
            data, response, error -> Void in
            
            guard let data = data,
                let responseString = String(data: data, encoding: .utf8) else
            {
                return
            }
            
            let json = dictionaryFrom(jsonString: responseString)
            print(json)
        }
        task.resume()
    }
}
