//
//  KeyChainManagable.swift
//  Utils
//
//  Created by 이준우 on 2023/05/30.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import Security

public protocol KeyChainManagable: AnyObject { }

extension KeyChainManagable {
    
    public func saveObject<T: Codable>(_ object: T, forKey key: ItemKey) throws {
        let encodedData = try JSONEncoder().encode(object)
        
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: encodedData,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        if let _ = try? getObject(asTypeOf: T.self, forKey: key) {
            try removeObject(object, forKey: key)
        }
                
        let addStatus = SecItemAdd(keychainQuery as CFDictionary, nil)
        if addStatus != errSecSuccess {
            throw KeyChainError.addingDataFailed(status: addStatus)
        }
    }
    
    public func getObject<T: Decodable>(asTypeOf targetType: T.Type, forKey key: ItemKey) throws -> T? {
        
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let loadStatus = SecItemCopyMatching(keychainQuery as CFDictionary, &result)
        
        if loadStatus != errSecSuccess {
            throw KeyChainError.gettingDataFailed(status: loadStatus)
        }
        
        guard let loadedData = result as? Data else {
            throw KeyChainError.nilData(status: loadStatus)
        }
                
        return try? JSONDecoder().decode(targetType, from: loadedData)
    }
    
    public func removeObject<T: Encodable>(_ object: T, forKey key: ItemKey) throws {
        let encodedData = try JSONEncoder().encode(object)
    
        let keychainQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
         ]
        
        let removalStatus = SecItemDelete(keychainQuery as CFDictionary)
        
        if removalStatus != errSecSuccess {
            throw KeyChainError.removingDataFailed(status: removalStatus)
        }
    }
}
