//
//  NetworkError.swift
//  Script_odont
//
//  Created by Régis Iozzino on 25/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

enum NetworkError: LocalizedError
{
    case notReachable
    case airplaneMode
    
    var errorDescription: String? {
        switch self
        {
        case .notReachable:
            return "NetworkError.NotReachable.LocalizedDescription".localized
        case .airplaneMode:
            return "NetworkError.Airplane.LocalizedDescription".localized
        }
    }
    
    var fixTip: String {
        switch self
        {
        case .notReachable:
            return "NetworkError.NotReachable.FixTip".localized
        case .airplaneMode:
            return "NetworkError.Airplane.FixTip".localized
        }
    }
}
