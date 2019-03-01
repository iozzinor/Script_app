//
//  KeychainPasswordItem.swift
//  Script_odont
//
//  Created by Régis Iozzino on 01/03/2019.
//  Copyright © 2019 Régis Iozzino. All rights reserved.
//

import Foundation

struct KeychainPasswordItem
{
    enum KeychainError: Error
    {
        case noPassword
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandledError(status: OSStatus)
    }
    
    let service: String
    private(set) var account: String
    
    let accessGroup: String?
    
    // -------------------------------------------------------------------------
    // MARK: - INITIALIZATION
    // -------------------------------------------------------------------------
    init(service: String, account: String, accessGroup: String? = nil)
    {
        self.service = service
        self.account = account
        self.accessGroup = accessGroup
    }
    
    // -------------------------------------------------------------------------
    // MARK: - KEYCHAIN ACCESS
    // -------------------------------------------------------------------------
    func readPassword() throws -> String
    {
        var query = KeychainPasswordItem.keychainQuery_(withService: service, account: account, accessGroup: accessGroup)
        
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        var queryResult: AnyObject? = nil
        let status = withUnsafeMutablePointer(to: &queryResult, {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        })
        
        guard status != errSecItemNotFound else {
            throw KeychainError.noPassword
        }
        guard status == noErr else {
            throw KeychainError.unhandledError(status: status)
        }
        
        guard let existingItem = queryResult as? [String: AnyObject],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8)
        else
        {
            throw KeychainError.unexpectedPasswordData
        }
        
        return password
    }
    
    func savePassword(_ password: String) throws
    {
        let encodedPassword = password.data(using: String.Encoding.utf8)!
        
        do
        {
            try _ = readPassword()
            
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedPassword as AnyObject?
            
            let query = KeychainPasswordItem.keychainQuery_(withService: service, account: account, accessGroup: accessGroup)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            guard status == noErr else
            {
                throw KeychainError.unhandledError(status: status)
            }
        }
        catch KeychainError.noPassword
        {
            var newItem = KeychainPasswordItem.keychainQuery_(withService: service, account: account, accessGroup: accessGroup)
            newItem[kSecValueData as String] = encodedPassword as AnyObject?
            
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            guard status == noErr else
            {
                throw KeychainError.unhandledError(status: status)
            }
        }
    }
    
    mutating func renameAccount(_ newAccountName: String) throws
    {
        var attributesToUpdate = [String: AnyObject]()
        attributesToUpdate[kSecAttrAccount as String] = newAccountName as AnyObject?
        
        let query = KeychainPasswordItem.keychainQuery_(withService: service, account: account, accessGroup: accessGroup)
        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        
        guard status == noErr || status == errSecItemNotFound else
        {
             throw KeychainError.unhandledError(status: status)
        }
        
        self.account = newAccountName
    }
    
    func deleteItem() throws
    {
        let query = KeychainPasswordItem.keychainQuery_(withService: service, account: account, accessGroup: accessGroup)
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == noErr || status == errSecItemNotFound else
        {
            throw KeychainError.unhandledError(status: status)
        }
    }
    
    static func passwordItems(forService service: String, accessGroup: String? = nil) throws -> [KeychainPasswordItem]
    {
        var query = KeychainPasswordItem.keychainQuery_(withService: service, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        var queryResult: AnyObject? = nil
        let status = withUnsafeMutablePointer(to: &queryResult, {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        })
        
        guard status != errSecItemNotFound else
        {
            return []
        }
        
        guard let resultData = queryResult as? [[String: AnyObject]] else
        {
            throw KeychainError.unexpectedItemData
        }
        
        var passwordItems = [KeychainPasswordItem]()
        
        for result in resultData
        {
            guard let account = result[kSecAttrAccount as String] as? String else
            {
                throw KeychainError.unexpectedItemData
            }
            
            let passwordItem = KeychainPasswordItem(service: service, account: account, accessGroup: accessGroup)
            passwordItems.append(passwordItem)
        }
        
        return passwordItems
    }
    
    // -------------------------------------------------------------------------
    // MARK: - CONVENIENCE
    // -------------------------------------------------------------------------
    fileprivate static func keychainQuery_(withService service: String, account: String? = nil,
                                           accessGroup: String? = nil) -> [String: AnyObject]
    {
        var query = [String: AnyObject]()
        
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
        
        if let account = account
        {
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        
        if let accessGroup = accessGroup
        {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        
        return query
    }
}
