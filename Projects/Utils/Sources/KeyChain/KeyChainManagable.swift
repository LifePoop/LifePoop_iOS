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
    
    func keychainQuery(for action: KeyChainAction, key: ItemKey, value: (any Encodable)? = nil) -> CFDictionary {
        
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
        ]
        
        switch action {
        case .get:
            query[kSecReturnData as String] = kCFBooleanTrue
            query[kSecMatchLimit as String] = kSecMatchLimitOne
        case .save:
            query[kSecValueData as String] = value
            query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked
        case .remove: break
        }
        
        return query as CFDictionary
    }
    
    public func saveObjectToKeyChain<T: Codable>(_ object: T, forKey key: ItemKey) async throws {
        let encodedData = try JSONEncoder().encode(object)
        
        let keychainQuery = keychainQuery(for: .get, key: key, value: encodedData)
        let isObjectAlreadyExists = (try await getObjectFromKeyChain(asTypeOf: T.self, forKey: key)) != nil
        if isObjectAlreadyExists {
            try await removeObjectFromKeyChain(object, forKey: key)
        }
                
        let addStatus = SecItemAdd(keychainQuery as CFDictionary, nil)
        if addStatus != errSecSuccess {
            throw KeyChainError.addingDataFailed(status: addStatus)
        }
    }
    
    public func getObjectFromKeyChain<T: Decodable>(
        asTypeOf targetType: T.Type,
        forKey key: ItemKey
    ) async throws -> T? {
        
        let keychainQuery = keychainQuery(for: .save, key: key)
        var result: AnyObject?
        let loadStatus = SecItemCopyMatching(keychainQuery, &result)
        
        switch loadStatus {
        case errSecSuccess: break
        case errSecItemNotFound: return nil
        default: throw KeyChainError.gettingDataFailed(status: loadStatus)
        }
        
        guard let loadedData = result as? Data else {
            throw KeyChainError.nilData(status: loadStatus)
        }
                
        return try JSONDecoder().decode(targetType, from: loadedData)
    }
    
    public func removeObjectFromKeyChain<T: Encodable>(_ object: T, forKey key: ItemKey) async throws {

        let keychainQuery = keychainQuery(for: .remove, key: key)
        let removalStatus = SecItemDelete(keychainQuery)
        
        if removalStatus != errSecSuccess {
            throw KeyChainError.removingDataFailed(status: removalStatus)
        }
    }
}
