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
}
