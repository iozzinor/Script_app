//
//  ConnectionError.swift
//  Script_odont
//
//  Created by Régis Iozzino on 27/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

enum ConnectionError: LocalizedError
{
    case noAccountLinked
    case wrongCredentials
    
    var errorDescription: String? {
        switch self
        {
        case .noAccountLinked:
            return "NetworkingService.ConnectionError.NoAccountLinked.LocalizedDescription".localized
        case .wrongCredentials:
            return "NetworkingService.ConnectionError.WrongCredentials.LocalizedDescription".localized
        }
    }
    
    var fixTip: String {
        switch self
        {
        case .noAccountLinked:
            return "NetworkingService.ConnectionError.NoAccountLinked.FixTip".localized
        case .wrongCredentials:
            return "NetworkingService.ConnectionError.WrongCredentials.FixTip".localized
        }
    }
}
