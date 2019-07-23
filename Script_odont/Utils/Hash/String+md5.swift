//
//  String+md5.swift
//  Script_odont
//
//  Created by Régis Iozzino on 20/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation
import CommonCrypto

extension String
{
    /// The digest of the current string using the MDA5 hash algorithm.
    var md5: String {
        guard let data = self.data(using: .utf8) else
        {
            return self
        }
        
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {
            digestBytes in
            data.withUnsafeBytes {
                messageBytes in
                
                CC_MD5(messageBytes, CC_LONG(data.count), digestBytes)
            }
        }
        
        return digestData.map {
            String(format: "%02hhx", $0)
            }.joined()
    }
}
