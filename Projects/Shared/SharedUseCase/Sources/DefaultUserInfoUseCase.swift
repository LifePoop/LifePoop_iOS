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
            .getObjectFromKeyChain(asTypeOf: UserInfoEntity.self, forKey: .userAuthInfo)
            .logErrorIfDetected(category: .authentication)
            .catchAndReturn(nil)
            .asObservable()
            .do(onNext: { userInfo in
                let nickname = userInfo?.nickname ?? "nil"
                let loginType = userInfo?.authInfo.loginType?.rawValue ?? "nil"
                Logger.log(
                    message: "사용자 정보 확인: \(nickname), 로그인 유형: \(loginType)",
                    category: .authentication,
                    type: .debug
                )
            })
    }
    
    private var isAppNotFirstlyLaunched: Observable<Bool> {
        userDefaultsRepository.getValue(for: .isAppNotFirstlyLaunched)
            .logErrorIfDetected(category: .database)
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
            .compactMap { $0 }
            .withUnretained(self)
            .flatMapLatest { `self`, userInfo in
                self.keyChainRepository
                    .removeObjectFromKeyChain(userInfo, forKey: .userAuthInfo)
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
