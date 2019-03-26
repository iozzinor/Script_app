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
    
    enum ConnectionError: LocalizedError
    {
        case noAccountLinked
        case wrongCredentials
        
        var errorDescription: String? {
            switch self
            {
            case .noAccountLinked:
                return "NetworkService.ConnectionError.NoAccountLinked.LocalizedDescription".localized
            case .wrongCredentials:
                return "NetworkService.ConnectionError.WrongCredentials.LocalizedDescription".localized
            }
        }
        
        var fixTip: String {
            switch self
            {
            case .noAccountLinked:
                return "NetworkService.ConnectionError.NoAccountLinked.FixTip".localized
            case .wrongCredentials:
                return "NetworkService.ConnectionError.WrongCredentials.FixTip".localized
            }
        }
    }
    
    private init()
    {
    }
    
    func getConnectionInformation(host: Host) throws -> ConnectionInformation
    {
        if let accountKey = Settings.shared.accountKey
        {
            return ConnectionInformation(host: host, accountKey: accountKey)
        }
        throw ConnectionError.noAccountLinked
    }
}
