//
//  DefaultUserInfoUseCase.swift
//  SharedUseCase
//
//  Created by Lee, Joon Woo on 2023/06/05.
//  Copyright © 2023 Lifepoo. All rights reserved.
//

import Foundation

import RxSwift

import CoreEntity
import SharedDIContainer
import Utils

public final class DefaultUserInfoUseCase: UserInfoUseCase {

    @Inject(SharedDIContainer.shared) private var userDefaultsRepository: UserDefaultsRepository
    @Inject(SharedDIContainer.shared) private var keyChainRepository: KeyChainRepository
    
    public init() { }

    public var userInfo: Observable<UserInfoEntity> {
        keyChainRepository
            .getObjectFromKeyChainAsSingle(asTypeOf: UserInfoEntity.self, forKey: .userAuthInfo)
            .asObservable()
    }
    
    private var isAppNotFirstlyLaunched: Observable<Bool> {
        userDefaultsRepository.getValue(for: .isAppNotFirstlyLaunched)
            .map { $0 ?? false }
            .catchAndReturn(false)
            .asObservable()
    }
    
    public func clearUserAuthInfoIfNeeded() -> Completable {
        isAppNotFirstlyLaunched
            .filter { !$0 }
            .withUnretained(self)
            .flatMapLatest { `self`, _ in
                self.keyChainRepository
                    .getObjectFromKeyChainAsSingle(asTypeOf: UserInfoEntity.self, forKey: .userAuthInfo)
            }
            .withUnretained(self)
            .flatMapLatest { `self`, userInfo in
                self.keyChainRepository
                    .removeObjectFromKeyChainAsCompletable(userInfo, forKey: .userAuthInfo)
                    .concat(self.userDefaultsRepository.updateValue(for: .isAppNotFirstlyLaunched, with: true))
            }
            .asCompletable()
    }
}
