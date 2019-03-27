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
    
    private init()
    {
    }
    
    func getConnectionInformation(host: Host) throws -> ConnectionInformation
    {
        guard let accountKey = Settings.shared.accountKey else
        {
            throw ConnectionError.noAccountLinked
        }
        
        return ConnectionInformation(host: host, accountKey: accountKey)
    }
}
