//
//  ConnectionInformation.swift
//  Script_odont
//
//  Created by Régis Iozzino on 26/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

struct ConnectionInformation
{
    var host: Host
    var accountKey: String
    var version: Int
    
    init(host: Host, accountKey: String)
    {
        self.host = host
        self.accountKey = accountKey
        version = 1
    }
}
