//
//  DefaultLoginUseCase.swift
//  FeatureLoginUseCase
//
//  Created by 김상혁 on 2023/04/26.
//  Copyright © 2023 LifePoop. All rights reserved.
//

import RxSwift

import CoreEntity
import FeatureLoginDIContainer
import Logger
import SharedDIContainer
import SharedUseCase
import Utils

public final class DefaultLoginUseCase: LoginUseCase {

    @Inject(LoginDIContainer.shared) private var loginRepository: LoginRepository
    @Inject(SharedDIContainer.shared) private var keyChainRepository: KeyChainRepository
    @Inject(SharedDIContainer.shared) private var userDefaultsRepository: UserDefaultsRepository

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
    
    public func saveUserInfo(_ userInfo: UserInfoEntity) -> Completable {
        keyChainRepository
            .saveObjectToKeyChain(userInfo, forKey: .userAuthInfo)
            .concat(self.userDefaultsRepository.updateValue(for: .userNickname, with: userInfo.nickname))
            .concat(self.userDefaultsRepository.updateValue(for: .userLoginType, with: userInfo.authInfo.loginType))
            .logErrorIfDetected(category: .authentication)
    }
    
    public func fetchUserAuthInfo(for loginType: LoginType) -> Observable<UserAuthInfoEntity?> {
        loginRepository.fetchAccessToken(for: loginType)
            .asObservable()
            .compactMap {
                switch loginType {
                case .apple:
                    return $0 as? AppleAuthResultEntity
                case .kakao:
                    return $0 as? KakaoAuthResultEntity
                }
            }
            .map { UserAuthInfoEntity(loginType: loginType, authToken: $0) }
            .logErrorIfDetected(category: .authentication)
    }
    
    public func clearUserAuthInfoIfNeeded() -> Completable {
        isAppFirstlyLaunched
            .do(onNext: {
                Logger.log(message: "앱 설치 후 최초 기동 여부 확인: \($0)", category: .authentication, type: .debug)
            })
            .filter { $0 }
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
                    .concat(self.userDefaultsRepository.updateValue(for: .isAppFirstlyLaunched, with: false))
            }
            .asCompletable()
    }
}

private extension DefaultLoginUseCase {
    
    var isAppFirstlyLaunched: Observable<Bool> {
        userDefaultsRepository.getValue(for: .isAppFirstlyLaunched)
            .logErrorIfDetected(category: .database)
            .map { $0 ?? true }
            .catchAndReturn(true)
            .asObservable()
    }
}
