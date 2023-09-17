//
//  DefaultKeyChainRepository.swift
//  SharedRepository
//
//  Created by 이준우 on 2023/06/04.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation
import Security

import RxSwift

import SharedUseCase

public final class DefaultKeyChainRepository: KeyChainRepository {
    
    public init() { }
    
    public func saveObjectToKeyChain<T: Codable>(
        _ object: T,
        forKey key: ItemKey
    ) -> Completable {
        Completable.create { [weak self] observer in
            
            do {
                try self?.saveNewObjectToKeyChain(object, forKey: key)
                observer(.completed)
            } catch let error {
                observer(.error(error))
            }
            
            return Disposables.create { }
        }
    }
    
    public func getObjectFromKeyChain<T: Decodable>(
        asTypeOf targetType: T.Type,
        forKey key: ItemKey
    ) -> Single<T?> {
        Single.create { [weak self] observer in
            
            do {
                guard let self = self else { throw KeyChainError.nilData(status: -999) }
                
                let targetObject: T? = try self.getObjectFromKeyChain(asTypeOf: targetType, forKey: key)
                observer(.success(targetObject))
            } catch let error {
                observer(.failure(error))
            }
            
            return Disposables.create { }
        }
    }
    
    public func removeObjectFromKeyChain<T: Encodable>(_ object: T, forKey key: ItemKey) -> Completable {
        Completable.create { [weak self] observer in
            
            do {
                try self?.removeExistingObjectFromKeyChain(object, forKey: key)
                observer(.completed)
            } catch let error {
                observer(.error(error))
            }
            
            return Disposables.create { }
        }
    }
}

private extension DefaultKeyChainRepository {
    
    func keychainQuery(for action: KeyChainAction, key: ItemKey, value: (any Encodable)? = nil) -> CFDictionary {
        
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue
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
    
    func saveNewObjectToKeyChain<T: Codable>(_ object: T, forKey key: ItemKey) throws {
        let encodedData = try JSONEncoder().encode(object)
        
        let keychainQuery = keychainQuery(for: .save, key: key, value: encodedData)
        let isObjectAlreadyExists = (try? getObjectFromKeyChain(asTypeOf: T.self, forKey: key)) != nil
        if isObjectAlreadyExists {
            try removeExistingObjectFromKeyChain(object, forKey: key)
        }
                
        let addStatus = SecItemAdd(keychainQuery as CFDictionary, nil)
        if addStatus != errSecSuccess {
            throw KeyChainError.addingDataFailed(status: addStatus)
        }
    }
    
    func getObjectFromKeyChain<T: Decodable>(
        asTypeOf targetType: T.Type,
        forKey key: ItemKey
    ) throws -> T? {
        
        let keychainQuery = keychainQuery(for: .get, key: key)
        var result: AnyObject?
        let loadStatus = SecItemCopyMatching(keychainQuery, &result)
        
        switch loadStatus {
        case errSecSuccess: break
        case errSecItemNotFound: throw KeyChainError.gettingDataFailed(status: loadStatus)
        default: throw KeyChainError.gettingDataFailed(status: loadStatus)
        }
        
        guard let loadedData = result as? Data else {
            throw KeyChainError.nilData(status: loadStatus)
        }
                
        return try JSONDecoder().decode(targetType, from: loadedData)
    }
    
    func removeExistingObjectFromKeyChain<T: Encodable>(_ object: T, forKey key: ItemKey) throws {

        let keychainQuery = keychainQuery(for: .remove, key: key)
        let removalStatus = SecItemDelete(keychainQuery)
        
        if removalStatus != errSecSuccess {
            throw KeyChainError.removingDataFailed(status: removalStatus)
        }
    }
}
