//
//  Sha1.swift
//  Script_odont
//
//  Created by Régis Iozzino on 01/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation
import CommonCrypto

fileprivate enum Sha2
{
    typealias ShaFunction = (UnsafeRawPointer?, CC_LONG, UnsafeMutablePointer<UInt8>?) -> UnsafeMutablePointer<UInt8>?
    
    // 224, 256, 384, 512, 512224, 512256
    case sha224
    case sha256
    case sha384
    case sha512
    
    var shaFunction: ShaFunction {
        switch self
        {
        case .sha224:
            return CC_SHA224
        case .sha256:
            return CC_SHA256
        case .sha384:
            return CC_SHA384
        case .sha512:
            return CC_SHA512
        }
    }
    
    var digestLength: Int32 {
        switch self
        {
        case .sha224:
            return CC_SHA224_DIGEST_LENGTH
        case .sha256:
            return CC_SHA256_DIGEST_LENGTH
        case .sha384:
            return CC_SHA384_DIGEST_LENGTH
        case .sha512:
            return CC_SHA512_DIGEST_LENGTH
        }
    }
    
    func digest(_ string: String) -> String
    {
        guard let data = string.data(using: String.Encoding.utf8) else
        {
            return string
        }
        
        var digestData = Data(count: Int(digestLength))
        
        _ = digestData.withUnsafeMutableBytes {
            digestBytes in
            data.withUnsafeBytes {
                messageBytes in
                
                shaFunction(messageBytes, CC_LONG(data.count), digestBytes)
            }
        }
        
        return digestData.map {
            String(format: "%02hhx", $0)
            }.joined()
    }
}

extension String
{
    var sha224: String {
        return Sha2.sha224.digest(self)
    }
    
    var sha256: String {
        return Sha2.sha256.digest(self)
    }
    
    var sha384: String {
        return Sha2.sha384.digest(self)
    }
    
    var sha512: String {
        return Sha2.sha512.digest(self)
    }
}
