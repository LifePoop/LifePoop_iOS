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
import Logger
import SharedDIContainer
import Utils

public final class DefaultUserInfoUseCase: UserInfoUseCase {

    @Inject(SharedDIContainer.shared) private var userDefaultsRepository: UserDefaultsRepository
    @Inject(SharedDIContainer.shared) private var keyChainRepository: KeyChainRepository
    
    public init() { }

    public var userInfo: Observable<UserInfoEntity?> {
        keyChainRepository
            .getObjectFromKeyChainAsSingle(asTypeOf: UserInfoEntity.self, forKey: .userAuthInfo)
            .catchAndReturn(nil)
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
            .do(onNext: {
                Logger.log(message: "앱 설치 후 최초 기동 여부 확인: \(!$0)", category: .authentication, type: .debug)
            })
            .filter { !$0 }
            .withUnretained(self)
            .do(onNext: { _, _ in
                Logger.log(message: "KeyChain에서 사용자 인증 정보를 확인합니다.", category: .authentication, type: .debug)
            })
            .flatMapLatest { `self`, _ in
                self.userInfo.catchAndReturn(nil)
            }
            .do(onNext: {
                Logger.log(
                    message: "사용자 닉네임:\($0?.nickname ?? "nil"), 로그인 유형:\($0?.authInfo.loginType?.rawValue ?? "nil")",
                    category: .authentication,
                    type: .debug
                )
            })
            .compactMap { $0 }
            .withUnretained(self)
            .flatMapLatest { `self`, userInfo in
                self.keyChainRepository
                    .removeObjectFromKeyChainAsCompletable(userInfo, forKey: .userAuthInfo)
                    .do(onCompleted: {
                        Logger.log(
                            message: "KeyChain에서 기존 사용자 정보 제거 완료",
                            category: .authentication,
                            type: .debug
                        )
                    })
                    .concat(self.userDefaultsRepository.updateValue(for: .isAppNotFirstlyLaunched, with: true))
            }
            .asCompletable()
    }
}
