//
//  ConnectionStatus.swift
//  Script_odont
//
//  Created by Régis Iozzino on 15/04/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

enum ConnectionStatus
{
    case unknown
    case information(ConnectionInformation)
    case error(Error)
}

