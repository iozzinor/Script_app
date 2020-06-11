//
//  Reachability.swift
//  Script_odont
//
//  Created by Régis Iozzino on 20/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation
import SystemConfiguration

struct Reachability
{
    fileprivate static let googleDnsHostName_ = "8.8.8.8"
    fileprivate static let reachability_ = SCNetworkReachabilityCreateWithName(nil, googleDnsHostName_)
    
    fileprivate static func networkStatus_(for flags: SCNetworkReachabilityFlags) -> NetworkStatus
    {
        if !flags.contains(.reachable)
        {
            return .notReachable
        }
        
        var result = NetworkStatus.notReachable
        
        if !flags.contains(.connectionRequired)
        {
            // the flags does not contain the required connection flag
            // assume the Wifi is enabled
            result = .reachableViaWifi
        }
        
        if flags.contains(.isWWAN)
        {
            result = .reachableViaWwan
        }
        
        return result
    }
    
    static var currentStatus: NetworkStatus
    {
        guard let reachability = Reachability.reachability_ else
        {
            return .notReachable
        }
        
        var result = NetworkStatus.notReachable
        
        var flags = SCNetworkReachabilityFlags()
        if SCNetworkReachabilityGetFlags(reachability, &flags)
        {
            result = Reachability.networkStatus_(for: flags)
        }
        
        return result
    }
}
