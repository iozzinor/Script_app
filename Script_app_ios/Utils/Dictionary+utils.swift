//
//  Dictionary+utils.swift
//  Script_odont
//
//  Created by Régis Iozzino on 07/04/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

typealias Json = Dictionary<String, Any>

// -------------------------------------------------------------------------
// MARK: - JSON DESERIALIZATION
// -------------------------------------------------------------------------
func dictionaryFrom(jsonString: String) -> Json?
{
    var result = Dictionary<String, Any>()
    
    guard let data = jsonString.data(using: .utf8) else
    {
        return nil
    }
    
    do
    {
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as! Json
        for (key, value) in jsonObject
        {
            result[key] = value
        }
    }
    catch
    {
        return nil
    }
    return result
}

extension Dictionary
{
    // -------------------------------------------------------------------------
    // MARK: - URL FORMATTNG
    // -------------------------------------------------------------------------
    func percentEscaped() -> String
    {
        return map {
            (key, value) in
            
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryValueAllowed) ?? ""
            
            return "\(escapedKey)=\(escapedValue)"
            
        }.joined(separator: "&")
    }
}
