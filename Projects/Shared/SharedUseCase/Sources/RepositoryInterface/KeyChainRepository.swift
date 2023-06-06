//
//  KeyChainRepository.swift
//  SharedUseCase
//
//  Created by 이준우 on 2023/06/04.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import Security

import RxSwift

public enum ItemKey: String {
    
    case userAuthInfo = "user_auth_info"
}

public enum KeyChainAction {
    
    case get
    case save
    case remove
}

public protocol KeyChainRepository: AnyObject {
    
    func keychainQuery(for action: KeyChainAction, key: ItemKey, value: (any Encodable)?) -> CFDictionary
    
    func saveObjectToKeyChain<T: Codable>(_ object: T, forKey key: ItemKey) throws
    
    func saveObjectToKeyChainAsCompletable<T: Codable>(_ object: T, forKey key: ItemKey) -> Completable
    
    func getObjectFromKeyChain<T: Decodable>(asTypeOf targetType: T.Type, forKey key: ItemKey) throws -> T?
    
    func getObjectFromKeyChainAsSingle<T: Decodable>(asTypeOf targetType: T.Type, forKey key: ItemKey) -> Single<T?>
    
    func removeObjectFromKeyChain<T: Encodable>(_ object: T, forKey key: ItemKey) throws
    
    func removeObjectFromKeyChainAsCompletable<T: Encodable>(_ object: T, forKey key: ItemKey) -> Completable
}
