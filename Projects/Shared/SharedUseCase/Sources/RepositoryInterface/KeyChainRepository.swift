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
    
    func saveObjectToKeyChain<T: Codable>(_ object: T, forKey key: ItemKey) -> Completable
    func getObjectFromKeyChain<T: Decodable>(
        asTypeOf targetType: T.Type,
        forKey key: ItemKey,
        handleExceptionWhenValueNotFound: Bool
    ) -> Single<T?>
    func getBinaryDataFromKeyChain(
        forKey key: ItemKey,
        handleExceptionWhenValueNotFound: Bool
    ) -> Single<Data?>
    func removeObjectFromKeyChain(forKey key: ItemKey) -> Completable
}

public extension KeyChainRepository {
    
    func getObjectFromKeyChain<T: Decodable>(
        asTypeOf targetType: T.Type,
        forKey key: ItemKey,
        handleExceptionWhenValueNotFound: Bool = true
    ) -> Single<T?> {
        getObjectFromKeyChain(
            asTypeOf: targetType,
            forKey: key,
            handleExceptionWhenValueNotFound: handleExceptionWhenValueNotFound
        )
    }
}
